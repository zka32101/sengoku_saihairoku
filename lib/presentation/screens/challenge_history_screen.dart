import 'package:flutter/material.dart';
import '../../data/repositories/daily_challenge_repository.dart';
import '../../data/models/daily_challenge.dart';
import '../widgets/challenge_card.dart';

class ChallengeHistoryScreen extends StatefulWidget {
  const ChallengeHistoryScreen({super.key});

  @override
  State<ChallengeHistoryScreen> createState() => _ChallengeHistoryScreenState();
}

class _ChallengeHistoryScreenState extends State<ChallengeHistoryScreen> {
  late DailyChallengeRepository _repository;
  late Future<List<({DateTime date, DailyChallenge? challenge, ChallengeProgress? progress})>>
      _last7Days;

  @override
  void initState() {
    super.initState();
    _repository = DailyChallengeRepository();
    _last7Days = Future.value(_repository.getLast7Days());
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _getDayOfWeek(DateTime date) {
    const days = ['日', '月', '火', '水', '木', '金', '土'];
    return days[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('チャレンジ履歴'),
        elevation: 0,
        backgroundColor: const Color(0xFF0A0A0A),
      ),
      body: FutureBuilder(
        future: _last7Days,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('チャレンジ履歴がありません'),
            );
          }

          final days = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF333333)),
                  ),
                  child: const Text(
                    'これまで7日間のチャレンジ情報',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(days.length, (index) {
                  final item = days[index];
                  final date = item.date;
                  final challenge = item.challenge;
                  final progress = item.progress;
                  final isToday = date.year == DateTime.now().year &&
                      date.month == DateTime.now().month &&
                      date.day == DateTime.now().day;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isToday
                              ? const Color(0xFF2A1A1A)
                              : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(6),
                          border: Border(
                            left: BorderSide(
                              color: isToday
                                  ? const Color(0xFFFFD700)
                                  : Colors.grey[700]!,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatDate(date),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '（${_getDayOfWeek(date)}）',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            if (isToday)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD700),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '本日',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            if (progress != null && progress.isCompleted)
                              Icon(
                                progress.claimed
                                    ? Icons.check_circle
                                    : Icons.radio_button_checked,
                                color: Colors.green,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (challenge != null)
                        ChallengeCard(
                          challenge: challenge,
                          progress: progress,
                          onTap: () {
                            // 詳細表示（後で実装）
                          },
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            border:
                                Border.all(color: Colors.grey[700]!, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'チャレンジ情報がありません',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
