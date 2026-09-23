import 'package:flutter/material.dart';
import '../../data/models/event_challenge.dart';

/// 期間限定イベントチャレンジのバナー（ホーム画面上部に表示）
class EventBanner extends StatelessWidget {
  final EventChallenge event;
  final EventChallengeProgress? progress;
  final VoidCallback onTap;
  final VoidCallback? onClaim;

  const EventBanner({
    super.key,
    required this.event,
    this.progress,
    required this.onTap,
    this.onClaim,
  });

  String _formatRemaining(Duration d) {
    if (d.inDays > 0) return 'あと${d.inDays}日${d.inHours % 24}時間';
    if (d.inHours > 0) return 'あと${d.inHours}時間${d.inMinutes % 60}分';
    return 'あと${d.inMinutes}分';
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress != null;
    final isClaimed = progress?.claimed ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B1A8B), Color(0xFF3B0A5B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD700), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event, color: Color(0xFFFFD700), size: 20),
                const SizedBox(width: 6),
                const Text(
                  '期間限定イベント',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatRemaining(event.remaining),
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event.description,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (event.rewardMultiplier > 1.0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '報酬${event.rewardMultiplier.toStringAsFixed(1)}倍',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B0A5B),
                      ),
                    ),
                  ),
                const Spacer(),
                if (isCompleted && !isClaimed)
                  ElevatedButton(
                    onPressed: onClaim,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: const Color(0xFF3B0A5B),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                    ),
                    child: const Text('報酬を受け取る',
                        style: TextStyle(fontSize: 12)),
                  )
                else if (isClaimed)
                  const Text('達成済み',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
