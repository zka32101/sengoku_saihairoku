import 'package:flutter/material.dart';
import '../../data/models/event_challenge.dart';
import '../../l10n/generated/app_localizations.dart';

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

  String _formatRemaining(AppLocalizations l10n, Duration d) {
    if (d.inDays > 0) {
      return l10n.eventBannerRemainingDays(d.inDays, d.inHours % 24);
    }
    if (d.inHours > 0) {
      return l10n.eventBannerRemainingHours(d.inHours, d.inMinutes % 60);
    }
    return l10n.eventBannerRemainingMinutes(d.inMinutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                Text(
                  l10n.eventBannerLimitedEventLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatRemaining(l10n, event.remaining),
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
                      l10n.eventBannerRewardMultiplier(
                          event.rewardMultiplier.toStringAsFixed(1)),
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
                    child: Text(l10n.eventBannerClaimRewardButton,
                        style: const TextStyle(fontSize: 12)),
                  )
                else if (isClaimed)
                  Text(l10n.eventBannerClaimedLabel,
                      style: const TextStyle(
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
