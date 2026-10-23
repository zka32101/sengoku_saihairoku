import 'package:flutter/material.dart';
import '../../core/services/firebase_service.dart';
import '../../data/repositories/onboarding_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import 'tutorial_battle_screen.dart';

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

List<_OnboardingPage> _pagesFor(AppLocalizations l10n) => [
  _OnboardingPage(
    icon: Icons.castle,
    title: l10n.onboardingPage1Title,
    description: l10n.onboardingPage1Description,
  ),
  _OnboardingPage(
    icon: Icons.trending_down,
    title: l10n.onboardingPage2Title,
    description: l10n.onboardingPage2Description,
  ),
  _OnboardingPage(
    icon: Icons.touch_app,
    title: l10n.onboardingPage3Title,
    description: l10n.onboardingPage3Description,
  ),
  _OnboardingPage(
    icon: Icons.emoji_events,
    title: l10n.onboardingPage4Title,
    description: l10n.onboardingPage4Description,
  ),
  _OnboardingPage(
    icon: Icons.military_tech,
    title: l10n.onboardingPage5Title,
    description: l10n.onboardingPage5Description,
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

  void _next(int pageCount) {
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _startTutorialBattle();
    }
  }

  void _startTutorialBattle() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TutorialBattleScreen(onFinished: _finish),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _pagesFor(l10n);
    final isLastPage = _currentPage == pages.length - 1;

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
                  child: Text(
                    l10n.onboardingSkipButton,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => _OnboardingPageView(page: pages[index]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
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
                  onPressed: () => _next(pages.length),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isLastPage
                      ? l10n.onboardingStartButton
                      : l10n.onboardingNextButton),
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
              color: const Color(0xFF8B1A1A).withValues(alpha: 0.2),
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
