import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_service.dart';
import '../../data/repositories/ad_reward_repository.dart';

/// リワード広告（動画視聴でゴールド獲得）を管理するサービス。
///
/// 注意：現在の広告ユニットIDはGoogle公式のテスト用IDです。
/// リリース前に AdMob コンソールで発行した本番の広告ユニットIDへ
/// 差し替えること（AndroidManifest.xml / Info.plist のAppID同様）。
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static String get _rewardedAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  final AdRewardRepository _adRewardRepo = AdRewardRepository();

  RewardedAd? _rewardedAd;
  bool _isLoading = false;

  bool get isAdReady => _rewardedAd != null;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await loadRewardedAd();
  }

  /// リワード広告を事前読み込み（既に読み込み済み/読み込み中なら何もしない）
  Future<void> loadRewardedAd() async {
    if (_rewardedAd != null || _isLoading) return;
    _isLoading = true;

    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          print('❌ Rewarded ad failed to load: $error');
          _rewardedAd = null;
          _isLoading = false;
        },
      ),
    );
  }

  /// 広告を表示し、最後まで視聴された場合のみゴールドを付与する。
  /// 戻り値：獲得できたか（広告が無い/視聴前に閉じた/日次上限到達の場合は false）
  Future<bool> showRewardedAdForGold() async {
    final userId = FirebaseService().userId;
    if (userId == null) return false;

    if (!await _adRewardRepo.canWatchToday(userId)) {
      return false;
    }

    final ad = _rewardedAd;
    if (ad == null) {
      // 未読み込みなら次回のために読み込んでおく
      loadRewardedAd();
      return false;
    }

    _rewardedAd = null; // 一度きりのインスタンスなので保持を解除

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        loadRewardedAd();
      },
    );

    bool earned = false;
    await ad.show(
      onUserEarnedReward: (adWithoutView, reward) {
        earned = true;
      },
    );

    if (!earned) return false;

    return _adRewardRepo.recordWatchAndReward(userId);
  }

  Future<int> getTodayWatchCount() async {
    final userId = FirebaseService().userId;
    if (userId == null) return 0;
    return _adRewardRepo.getTodayWatchCount(userId);
  }

  int get dailyWatchLimit => AdRewardRepository.dailyWatchLimit;
  int get rewardGoldAmount => AdRewardRepository.rewardGoldAmount;
}
