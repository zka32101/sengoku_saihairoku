import 'package:flutter/material.dart';
import '../../data/models/daily_login_bonus.dart';

/// デイリーログインボーナス受取ダイアログ
class DailyLoginDialog extends StatelessWidget {
  final DailyLoginStatus status;
  final VoidCallback onClaim;

  const DailyLoginDialog({
    super.key,
    required this.status,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A1A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF8B6914), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFFFFD700), size: 40),
            const SizedBox(height: 12),
            const Text(
              '本日のログインボーナス',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '連続ログイン ${status.currentStreak}日目',
              style: const TextStyle(color: Color(0xFFE8D5B0)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: DailyLoginBonus.goldByDay.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isToday =
                      ((status.currentStreak - 1) % 7) + 1 == day;
                  return Container(
                    width: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday
                          ? const Color(0xFFFFD700)
                          : const Color(0xFF3B1A1A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isToday ? const Color(0xFF3B1A1A) : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Color(0xFFFFD700)),
                const SizedBox(width: 6),
                Text(
                  '+${status.todayReward}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  onClaim();
                  Navigator.pop(context);
                },
                child: const Text('受け取る'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
