/// チュートリアル・ヘルプシステムのモデル
class TutorialContent {
  final String id;
  final String title;
  final String description;
  final List<TutorialTip> tips;

  TutorialContent({
    required this.id,
    required this.title,
    required this.description,
    required this.tips,
  });

  factory TutorialContent.fromJson(Map<String, dynamic> json) {
    return TutorialContent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      tips: (json['tips'] as List)
          .map((tip) => TutorialTip.fromJson(tip as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'tips': tips.map((tip) => tip.toJson()).toList(),
      };
}

/// チュートリアルのヒント・説明
class TutorialTip {
  final String id;
  final String title;
  final String content;
  final String category; // 'command', 'strategy', 'mechanics'
  final String? difficulty; // null, 'easy', 'normal', 'hard' - null means all difficulties
  final String? icon;

  TutorialTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.difficulty,
    this.icon,
  });

  factory TutorialTip.fromJson(Map<String, dynamic> json) {
    return TutorialTip(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String?,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'category': category,
        if (difficulty != null) 'difficulty': difficulty,
        if (icon != null) 'icon': icon,
      };
}

/// コマンドの説明
class CommandHelp {
  final String commandName;
  final String displayName;
  final String description;
  final String effect;
  final String limitation;

  CommandHelp({
    required this.commandName,
    required this.displayName,
    required this.description,
    required this.effect,
    required this.limitation,
  });

  factory CommandHelp.fromJson(Map<String, dynamic> json) {
    return CommandHelp(
      commandName: json['commandName'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      effect: json['effect'] as String,
      limitation: json['limitation'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'commandName': commandName,
        'displayName': displayName,
        'description': description,
        'effect': effect,
        'limitation': limitation,
      };
}

/// 難易度別の戦術ヒント
class TacticalHint {
  final String difficultyLevel; // 'easy', 'normal', 'hard'
  final String title;
  final String content;
  final List<String> recommendations;

  TacticalHint({
    required this.difficultyLevel,
    required this.title,
    required this.content,
    required this.recommendations,
  });

  factory TacticalHint.fromJson(Map<String, dynamic> json) {
    return TacticalHint(
      difficultyLevel: json['difficultyLevel'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      recommendations: List<String>.from(json['recommendations'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
        'difficultyLevel': difficultyLevel,
        'title': title,
        'content': content,
        'recommendations': recommendations,
      };
}
