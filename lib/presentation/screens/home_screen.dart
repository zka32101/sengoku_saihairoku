import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/notification_service.dart';
import '../../data/repositories/daily_challenge_repository.dart';
import '../../data/repositories/event_challenge_repository.dart';
import '../../data/repositories/currency_repository.dart';
import '../../data/models/daily_challenge.dart';
import '../../data/models/event_challenge.dart';
import '../widgets/challenge_card.dart';
import '../widgets/event_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DailyChallengeRepository _challengeRepo;
  late EventChallengeRepository _eventChallengeRepo;
  DailyChallenge? _todayChallenge;
  ChallengeProgress? _todayProgress;
  EventChallenge? _activeEvent;
  EventChallengeProgress? _eventProgress;

  @override
  void initState() {
    super.initState();
    _challengeRepo = DailyChallengeRepository();
    _eventChallengeRepo = EventChallengeRepository();
    _loadTodayChallenge();
    _loadActiveEvent();
  }

  Future<void> _loadActiveEvent() async {
    final event = await _eventChallengeRepo.getActiveEvent();
    if (event == null) {
      setState(() => _activeEvent = null);
      return;
    }

    final userId = FirebaseService().userId;
    final progress = userId != null
        ? await _eventChallengeRepo.getProgress(userId, event.id)
        : null;

    if (!mounted) return;
    setState(() {
      _activeEvent = event;
      _eventProgress = progress;
    });
  }

  Future<void> _claimEventReward() async {
    final event = _activeEvent;
    final userId = FirebaseService().userId;
    if (event == null || userId == null) return;

    await CurrencyRepository().addGold(
      userId,
      (event.baseReward * event.rewardMultiplier).round(),
      source: 'event_challenge_${event.id}',
    );
    await _eventChallengeRepo.claimReward(userId, event.id);
    await _loadActiveEvent();
  }

  Future<void> _loadTodayChallenge() async {
    final challenge = _challengeRepo.getTodayChallenge();
    final progress = _challengeRepo.getTodayProgress();
    setState(() {
      _todayChallenge = challenge;
      _todayProgress = progress;
    });

    // 未達成なら翌日にリマインダー通知を予約、達成済みなら解除
    if (challenge != null && (progress == null || !progress.isCompleted)) {
      await NotificationService().scheduleDailyChallengeReminder();
    } else {
      await NotificationService().cancelDailyChallengeReminder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_activeEvent != null)
                      EventBanner(
                        event: _activeEvent!,
                        progress: _eventProgress,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/scenario_select',
                          );
                        },
                        onClaim: _claimEventReward,
                      ),
                    if (_todayChallenge != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '本日のチャレンジ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ChallengeCard(
                            challenge: _todayChallenge!,
                            progress: _todayProgress,
                            onTap: () {
                              // チャレンジ詳細表示（後で実装）
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    _buildSpotBattleCard(context),
                    const SizedBox(height: 16),
                    _buildReplayCard(context),
                    const SizedBox(height: 16),
                    _buildRankingCard(context),
                    const SizedBox(height: 16),
                    _buildChallengeHistoryCard(context),
                    const SizedBox(height: 16),
                    _buildBattlePassCard(context),
                    const SizedBox(height: 16),
                    _buildGoldShopCard(context),
                    const SizedBox(height: 16),
                    _buildFriendsCard(context),
                  ],
                ),
              ),
            ),
            _buildBottomNav(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3B1A1A), Color(0xFF1A0F0A)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            '戦国采配録',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '天下を狙え',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotBattleCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.castle, color: Color(0xFFFFD700), size: 28),
                SizedBox(width: 8),
                Text(
                  'スポット戦',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '有名な合戦を選んで采配を振るえ',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 4),
            Text(
              'プレイ時間: 3〜8分',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/scenario_select'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('シナリオを選ぶ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplayCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.videocam, color: Color(0xFFFFD700), size: 28),
                SizedBox(width: 8),
                Text(
                  'バトルリプレイ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '過去のバトルを再生・分析する',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 4),
            Text(
              'すべてのバトルは自動で記録されます',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/replay'),
                icon: const Icon(Icons.play_circle, color: Color(0xFFFFD700)),
                label: const Text(
                  'リプレイを見る',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFD700)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.leaderboard, color: Color(0xFFFFD700), size: 28),
                SizedBox(width: 8),
                Text(
                  'ランキング',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '他の武将の采配と競え',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/ranking'),
                icon: const Icon(Icons.bar_chart, color: Color(0xFFFFD700)),
                label: const Text(
                  'ランキングを見る',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFD700)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeHistoryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.card_giftcard, color: Color(0xFFFFD700), size: 28),
                SizedBox(width: 8),
                Text(
                  'チャレンジ履歴',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '過去7日間のチャレンジを確認',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/challenge_history'),
                icon: const Icon(Icons.history, color: Color(0xFFFFD700)),
                label: const Text(
                  'チャレンジ履歴を見る',
                  style: TextStyle(color: Color(0xFFFFD700)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFD700)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.people, color: Colors.lightGreenAccent, size: 28),
                SizedBox(width: 8),
                Text(
                  'フレンド',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'フレンドコードを交換してランキングを競おう',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/friends'),
                icon: const Icon(Icons.people, color: Colors.lightGreenAccent),
                label: const Text(
                  'フレンドを見る',
                  style: TextStyle(color: Colors.lightGreenAccent),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.lightGreenAccent),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoldShopCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text(
                  'ゴールドショップ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ゴールドを購入してバトルパスの進行を加速',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/gold_shop'),
                icon: const Icon(Icons.monetization_on, color: Colors.amber),
                label: const Text(
                  'ショップを見る',
                  style: TextStyle(color: Colors.amber),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.amber),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBattlePassCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.card_membership, color: Colors.cyan, size: 28),
                SizedBox(width: 8),
                Text(
                  'バトルパス',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'シーズンを通してティアをアップ',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/battle_pass'),
                icon: const Icon(Icons.trending_up, color: Colors.cyan),
                label: const Text(
                  'バトルパスを見る',
                  style: TextStyle(color: Colors.cyan),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.cyan),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF8B6914), width: 1)),
        color: Color(0xFF2A1A0A),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _navItem(context, Icons.home, 'ホーム', '/home', selected: true),
            _navItem(context, Icons.person, 'プロフィール', '/profile'),
            _navItem(context, Icons.bar_chart, '統計', '/statistics'),
            _navItem(context, Icons.videocam, 'リプレイ', '/replay'),
            _navItem(context, Icons.leaderboard, 'ランキング', '/ranking'),
            _navItem(context, Icons.settings, '設定', '/settings'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, String route,
      {bool selected = false}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // ranking/settings画面の下部ナビと挙動を揃える（スタックを積み上げず置換する）
          if (!selected) {
            Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? const Color(0xFFFFD700) : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? const Color(0xFFFFD700) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
