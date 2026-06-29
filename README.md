# 戦国采配録 (Sengoku Saihairoku)

2.5D見下ろし型リアルタイムアクション戦闘ゲーム

**開発期間**: 2026年6月下旬～10月（約5-6ヶ月）  
**ターゲット**: iOS 14+ / Android 10+  
**開発スタック**: Flutter 3.x + Flame + Firebase

---

## 🎮 ゲーム概要

戦国時代の4つの戦役を「見下ろし型のリアルタイム戦闘」で体験。
プレイヤーは指揮官として、リアルタイムで兵を指揮し敵軍を撃破します。

**4つのシナリオ**:
- 桶狭間（⭐ 初心者向け）
- 長篠（⭐⭐ 中級）
- 本能寺（⭐⭐⭐ 上級）
- 関ヶ原（⭐⭐⭐⭐ エキスパート）

---

## 📁 プロジェクト構成

```
lib/
├── core/                    # 設定・サービス・ユーティリティ
│   ├── constants/           # アプリ定数
│   ├── services/            # Firebase, Message, Analytics
│   └── utils/               # Logger, Helper関数
├── data/                    # データ層
│   ├── models/              # データクラス定義
│   └── repositories/        # Firestore読取・書込
├── domain/                  # ビジネスロジック
│   ├── combat/              # Unit, Army, DamageCalculator
│   ├── ai/                  # EnemyAI状態機械
│   ├── scoring/             # スコア計算, TP評価
│   └── state/               # BattleState
├── presentation/            # UI層
│   ├── screens/             # 各画面
│   ├── widgets/             # 再利用可能ウィジェット
│   └── providers/           # Riverpodプロバイダ
├── flame/                   # Flameゲーム実装
│   ├── components/          # UnitSprite, Background, Effect
│   └── utils/               # SpriteLoader
└── main.dart                # アプリエントリーポイント
```

---

## 🚀 実装フェーズ

| Phase | 期間 | 内容 | 状態 |
|-------|------|------|------|
| **1** | 6月下旬 | Flutter初期設定 + pubspec.yaml | ✅ 完了 |
| **2** | 7月 | データ層・リポジトリ | ⏳ 予定 |
| **3** | 7月中旬-8月初旬 | 戦闘コア | ⏳ 予定 |
| **4** | 7月下旬-8月 | AI・スコア・TP | ⏳ 予定 |
| **5** | 8月 | UI・画面遷移・Firebase統合 | ⏳ 予定 |
| **6** | 8月下旬-9月 | Flame実装・4シナリオ調整 | ⏳ 予定 |

---

## 🔧 技術スタック

- **エンジン**: Flame 1.10.0（2D軽量ゲーム）
- **状態管理**: Riverpod
- **Database**: Firebase Firestore + Hive（ローカル）
- **Audio**: just_audio + flame_audio
- **Animation**: Rive（ベクターアニメ）
- **Monetization**: RevenueCat

---

## 📝 設計書参照

すべて `G:\マイドライブ\design\戦略采配録\` に保存済み：

1. **企画書**: v2.1最終版
2. **詳細設計①**: 画面フロー
3. **詳細設計②**: 戦闘ロジック
4. **詳細設計③④**: Flame・Firestore統合版

---

**リリース目標**: 2026年10月 🎉
