/// 武将データモデル。
///
/// 各武将は統率(leadership)・武勇(valor)・知略(intelligence)の3軸ステータスと
/// 所属勢力(faction)を持つ。現時点ではデータ層のみで、戦闘（Unit/Army）への
/// 反映は未実装 —— プレイヤーが武将をユニットに割り当てるUIやセーブ形式の
/// 設計が別途必要なため（PR #9のスコープ外整理を参照）。
/// 相性計算は [WarlordCompatibility] を参照。
class Warlord {
  final String id;
  final String name;
  final String faction;
  final int leadership; // 統率
  final int valor; // 武勇
  final int intelligence; // 知略

  const Warlord({
    required this.id,
    required this.name,
    required this.faction,
    required this.leadership,
    required this.valor,
    required this.intelligence,
  });

  factory Warlord.fromJson(Map<String, dynamic> json) {
    return Warlord(
      id: json['id'] as String,
      name: json['name'] as String,
      faction: json['faction'] as String,
      leadership: json['leadership'] as int,
      valor: json['valor'] as int,
      intelligence: json['intelligence'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'faction': faction,
        'leadership': leadership,
        'valor': valor,
        'intelligence': intelligence,
      };

  int get totalStat => leadership + valor + intelligence;
}
