import 'package:flutter/material.dart';
import '../../data/models/battle_pass.dart';

class BattlePassNotificationService {
  static final BattlePassNotificationService _instance =
      BattlePassNotificationService._internal();
  OverlayEntry? _currentEntry;
  late BuildContext _context;

  factory BattlePassNotificationService() {
    return _instance;
  }

  BattlePassNotificationService._internal();

  void initialize(BuildContext context) {
    _context = context;
  }

  /// ティアアップ通知を表示
  Future<void> showTierUpNotification(
    int newTier,
    BattlePassTier tierData,
  ) async {
    _removeCurrentNotification();

    _currentEntry = OverlayEntry(
      builder: (context) => BattlePassTierUpNotification(
        newTier: newTier,
        tierData: tierData,
        onDismiss: _removeCurrentNotification,
      ),
    );

    Overlay.of(_context).insert(_currentEntry!);
    await Future.delayed(const Duration(seconds: 5));
    _removeCurrentNotification();
  }

  /// 報酬アンロック通知を表示
  Future<void> showRewardUnlockNotification(BattlePassTier tierData) async {
    _removeCurrentNotification();

    _currentEntry = OverlayEntry(
      builder: (context) => BattlePassRewardNotification(
        tierData: tierData,
        onDismiss: _removeCurrentNotification,
      ),
    );

    Overlay.of(_context).insert(_currentEntry!);
    await Future.delayed(const Duration(seconds: 5));
    _removeCurrentNotification();
  }

  /// プレミアムアクティベート通知を表示
  Future<void> showPremiumActivateNotification() async {
    _removeCurrentNotification();

    _currentEntry = OverlayEntry(
      builder: (context) => BattlePassPremiumNotification(
        onDismiss: _removeCurrentNotification,
      ),
    );

    Overlay.of(_context).insert(_currentEntry!);
    await Future.delayed(const Duration(seconds: 5));
    _removeCurrentNotification();
  }

  void _removeCurrentNotification() {
    _currentEntry?.remove();
    _currentEntry = null;
  }

  void clear() {
    _removeCurrentNotification();
  }
}

class BattlePassTierUpNotification extends StatefulWidget {
  final int newTier;
  final BattlePassTier tierData;
  final VoidCallback onDismiss;

  const BattlePassTierUpNotification({
    super.key,
    required this.newTier,
    required this.tierData,
    required this.onDismiss,
  });

  @override
  State<BattlePassTierUpNotification> createState() =>
      _BattlePassTierUpNotificationState();
}

class _BattlePassTierUpNotificationState
    extends State<BattlePassTierUpNotification> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 64,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        ),
        child: FadeTransition(
          opacity: _fadeController,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(0.3),
                  Colors.blue.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.cyan,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'バトルパス ティアアップ！',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: const Icon(
                        Icons.close,
                        color: Colors.cyan,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.2),
                        border: Border.all(color: Colors.cyan, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          widget.newTier.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tierData.rewardName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE8D5B0),
                            ),
                          ),
                          if (widget.tierData.rewardDescription != null)
                            Text(
                              widget.tierData.rewardDescription!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BattlePassRewardNotification extends StatefulWidget {
  final BattlePassTier tierData;
  final VoidCallback onDismiss;

  const BattlePassRewardNotification({
    super.key,
    required this.tierData,
    required this.onDismiss,
  });

  @override
  State<BattlePassRewardNotification> createState() =>
      _BattlePassRewardNotificationState();
}

class _BattlePassRewardNotificationState
    extends State<BattlePassRewardNotification> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 64,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        ),
        child: FadeTransition(
          opacity: _fadeController,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.3),
                  Colors.teal.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.green,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '報酬獲得！',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: const Icon(
                        Icons.close,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.tierData.rewardName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8D5B0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BattlePassPremiumNotification extends StatefulWidget {
  final VoidCallback onDismiss;

  const BattlePassPremiumNotification({
    super.key,
    required this.onDismiss,
  });

  @override
  State<BattlePassPremiumNotification> createState() =>
      _BattlePassPremiumNotificationState();
}

class _BattlePassPremiumNotificationState
    extends State<BattlePassPremiumNotification> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 64,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        ),
        child: FadeTransition(
          opacity: _fadeController,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.3),
                  Colors.pink.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.purple,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'プレミアム アクティベート',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: const Icon(
                        Icons.close,
                        color: Colors.purple,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'プレミアムトラックの全報酬がアンロックされました',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFE8D5B0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
