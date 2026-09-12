import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';

/// 実績解放通知を管理するサービス
class AchievementNotificationService {
  static final AchievementNotificationService _instance =
      AchievementNotificationService._internal();

  final List<Achievement> _unlockedAchievements = [];
  late BuildContext _context;
  OverlayEntry? _currentOverlay;

  factory AchievementNotificationService() {
    return _instance;
  }

  AchievementNotificationService._internal();

  /// 初期化（BuildContextを設定）
  void initialize(BuildContext context) {
    _context = context;
  }

  /// 実績解放を記録して通知を表示
  Future<void> showAchievementUnlockNotification(
    Achievement achievement,
  ) async {
    _unlockedAchievements.add(achievement);
    
    // 通知を表示
    await _displayNotification(achievement);
    
    // 効果音を再生（将来実装）
    // await _playUnlockSound();
  }

  /// 複数の実績を一度に表示
  Future<void> showMultipleAchievementNotifications(
    List<Achievement> achievements,
  ) async {
    if (achievements.isEmpty) return;

    for (final achievement in achievements) {
      _unlockedAchievements.add(achievement);
      await _displayNotification(achievement);
      // 複数表示の場合は少し間隔を空ける
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// 通知をUI上に表示
  Future<void> _displayNotification(Achievement achievement) async {
    // 前の通知を削除
    _currentOverlay?.remove();

    final overlay = Overlay.of(_context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => AchievementNotificationWidget(
        achievement: achievement,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    // 5秒後に自動削除
    await Future.delayed(const Duration(seconds: 5));
    if (_currentOverlay == overlayEntry) {
      overlayEntry.remove();
      _currentOverlay = null;
    }
  }

  /// 解放済み実績のリストを取得
  List<Achievement> getUnlockedAchievements() => _unlockedAchievements.toList();

  /// 通知状態をクリア
  void clear() {
    _unlockedAchievements.clear();
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

/// 実績解放通知ウィジェット
class AchievementNotificationWidget extends StatefulWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementNotificationWidget({
    super.key,
    required this.achievement,
    required this.onDismiss,
  });

  @override
  State<AchievementNotificationWidget> createState() =>
      _AchievementNotificationWidgetState();
}

class _AchievementNotificationWidgetState
    extends State<AchievementNotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF3A2A1A),
                      const Color(0xFF2A1A0A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFD700),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with achievement icon
                    Row(
                      children: [
                        // Achievement Icon
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF8B1A1A),
                            border: Border.all(
                              color: const Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.achievement.icon ?? '🏆',
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Achievement Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '実績解放！',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFD700),
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.achievement.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Close Button
                        GestureDetector(
                          onTap: widget.onDismiss,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.close,
                              color: Color(0xFFB0A090),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A0F0A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.achievement.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE8D5B0),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    if (widget.achievement.points != null) ...[
                      const SizedBox(height: 10),
                      // Points Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFD700),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '+${widget.achievement.points} ポイント',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
