# CLAUDE.md — 開発メモ・既知の落とし穴

このファイルは過去の開発で踏んだ不具合パターンを記録し、再発を防ぐためのものです。
新しい変更を行う前に該当項目がないか確認してください。

## 1. 新しい `Scenario` を追加するときは全ファイルを同期させる

`Scenario` enum (`lib/data/models/scenario_data.dart`) に値を1つ追加すると、
**最低でも以下9箇所**を同時に更新する必要があります。1つでも漏れると、
switch式(`=>`)ではコンパイルエラーになりますが、`default:`付きのswitch文や
Mapリテラルでは**サイレントに機能しない**（無音・無表示・スコア0など）ため、
特に注意が必要です。

1. `assets/data/scenarios.json` — シナリオ本体データ（id, turningPoints, units等）
2. `assets/data/messages.json` — 結果画面メッセージ（キーは`Scenario.値.name`と完全一致させること。下記2項参照）
3. `lib/data/models/scenario_data.dart` — `enum Scenario` に値を追加
4. `lib/domain/scoring/turning_point_evaluator.dart` — `_checkCondition`内の
   `switch (scenarioId)` に新規caseを追加。既存の最後尾だったcaseは
   非最後尾になるため`break;`の付け忘れに注意（fallthroughでコンパイルエラー）
5. `lib/flame/battle_game.dart` — `_getBattleBgmPath()`にBGMパスを追加
6. `lib/flame/components/map_background.dart` — `_drawTerrain`のswitchに
   マップ描画caseを追加
7. `lib/presentation/screens/ranking_screen.dart` — `_getScenarioName`に
   表示名を追加
8. `lib/presentation/screens/result_screen.dart` — `_tpNames`マップに
   ターニングポイント名リストを追加（**scenarios.jsonの`turningPoints[].name`と
   1文字違わず一致させること** — ズレると結果画面の表示だけが不整合になる）
9. `lib/presentation/screens/scenario_select_screen.dart` — `_scenarios`
   リストに`_ScenarioEntry`を追加

新規シナリオPRでは、この一覧をチェックリストとして使い、grep等で
既存シナリオ（例: `kawanakajima`）を検索して漏れがないか横断確認すること。

## 2. JSONのキーは `Scenario.値.name` と完全一致させる

`messages.json`や`scenarios.json`のトップレベルキーは、コード側で
`Scenario.values.byName(key)`や`messages[scenario.name]`のような形で
**文字列一致**で引かれる。Dartの`enum`メンバー名と1文字でも違う
キー（例: スネークケース`honnou_ji` vs キャメルケース`honnoJi`）を使うと、
例外は発生せず「該当メッセージが見つからない／デフォルト値にフォールバック」
という形でサイレントに壊れる。実際に`messages.json`の`honnou_ji`キーが
`Scenario.honnoJi.name`（`"honnoJi"`）と一致せず、本能寺の変クリア後の
エピローグ文が一度も表示されない不具合があった（修正済み）。

**教訓**: enumに紐づくJSONキーを追加・変更するときは、必ず
`enum_name.name`の実際の文字列値を確認してから記述する。

## 3. 戦闘バランスは「介入なしシミュレーション」だけで判断しない

各シナリオの初期兵力比（例: 桶狭間 3500 vs 15000、本能寺 500 vs 13000、
川中島 4000 vs 9000）は、いずれも歴史上の劣勢局面を再現した
意図的なアンダードッグ設定であり、`description`にも「大逆転劇」
「絶望的な状況での逆転を目指す」等と明記されている。

プレイヤーコマンド（奇襲・盾陣・進軍・撤退・鼓舞等）を一切使わない
「全ユニット総当たり」または「1vs1逐次デュエル」の機械的シミュレーションでは、
ほぼ全シナリオでプレイヤーが劣勢〜敗北という結果になるが、これは
**コマンドによる戦術介入を一切モデル化していない**ためであり、
実プレイでのバランス崩壊を意味しない。このゲームのコアループは
「不利な兵力を戦術コマンドで覆す」ことを前提に設計されているため、
無介入シミュレーションの結果だけを根拠に兵力・ステータスを調整しないこと。

バランス調整を検討する場合は、`PlayerCommand`（奇襲/盾陣/進軍/撤退/鼓舞/突撃等）
の効果を反映したシミュレーション、または実機プレイテストのログを
根拠にすること。
