import 'package:cloud_firestore/cloud_firestore.dart';

/// プレイヤーのゴールド（ゲーム内通貨）残高
class CurrencyWallet {
  final String userId;
  final int gold;
  final DateTime updatedAt;

  const CurrencyWallet({
    required this.userId,
    required this.gold,
    required this.updatedAt,
  });

  factory CurrencyWallet.empty(String userId) => CurrencyWallet(
        userId: userId,
        gold: 0,
        updatedAt: DateTime.now(),
      );

  factory CurrencyWallet.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CurrencyWallet(
      userId: data['userId'] as String,
      gold: data['gold'] as int? ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'gold': gold,
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  CurrencyWallet copyWith({int? gold}) => CurrencyWallet(
        userId: userId,
        gold: gold ?? this.gold,
        updatedAt: DateTime.now(),
      );
}

/// ゴールド増減の履歴記録（監査・不整合調査用）
class CurrencyTransaction {
  final int amount; // 正=獲得、負=消費
  final String source; // 例: "battle_pass", "iap:gold_pack_medium", "shop_purchase"
  final DateTime createdAt;

  const CurrencyTransaction({
    required this.amount,
    required this.source,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'amount': amount,
        'source': source,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
