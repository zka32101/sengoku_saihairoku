import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/repositories/onboarding_repository.dart';

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const _pages = [
  _OnboardingPage(
    icon: Icons.castle,
    title: '戦国采配録へようこそ',
    description: '桶狭間、本能寺、関ヶ原…\n'
        '兵力で劣る武将となり、采配一つで\n'
        '歴史に残る大逆転劇を実現せよ。',
  ),
  _OnboardingPage(
    icon: Icons.trending_down,
    title: '圧倒的劣勢から始まる',
    description: '多くのシナリオでは、敵の兵力が\n'
        'あなたの数倍〜十数倍に達する。\n'
        '正面からの力押しでは勝てない。',
  ),
  _OnboardingPage(
    icon: Icons.touch_app,
    title: 'コマンドで戦況を動かす',
    description: '奇襲・盾陣・進軍・撤退・鼓舞・突撃…\n'
        '状況に応じたコマンドの選択こそが\n'
        '勝敗を分ける采配の要。',
  ),
  _OnboardingPage(
    icon: Icons.emoji_events,
    title: 'ターニングポイントを狙え',
    description: '各シナリオには史実に基づいた\n'
        '「ターニングポイント」が用意されている。\n'
        '条件を満たして達成し、高得点を狙おう。',
  ),
  _OnboardingPage(
    icon: Icons.military_tech,
    title: '成長し続ける武将',
    description: 'レベル・実績・バトルパス・プレスティジ…\n'
        '戦えば戦うほど武将は成長する。\n'
        'さあ、初陣の采配を振るおう！',
  ),
];

/// 初回起動時に表示する導入チュートリアル（オンボーディング）。
/// 設定画面からいつでも再表示できる。
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final userId = FirebaseService().userId;
    if (userId != null) {
      await OnboardingRepository().markCompleted(userId);
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: _finish,
                  child: const Text(
                    'スキップ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _OnboardingPageView(page: _pages[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentPage ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? const Color(0xFFFFD700)
                        : Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isLastPage ? '初陣へ' : '次へ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF8B1A1A).withOpacity(0.2),
              border: Border.all(color: const Color(0xFFFFD700), width: 2),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 56, color: const Color(0xFFFFD700)),
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFE8D5B0),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
