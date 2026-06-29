enum PlayerCommand {
  advance,    // 進軍
  retreat,    // 撤退
  wait,       // 待機
  ambush,     // 奇襲
  formation,  // 陣形変更
  rally,      // 激励（攻撃力バフ10秒）
  shield,     // 盾陣（防御力バフ10秒）
  charge,     // 突撃（速度バフ+全進軍）
}

class CommandRecord {
  final PlayerCommand command;
  final double timestamp;

  CommandRecord({required this.command, required this.timestamp});
}

class BattleEventLog {
  final List<CommandRecord> commands = [];
  bool enemyCommanderKilled = false;
  double _elapsedTime = 0;

  void tick(double dt) {
    _elapsedTime += dt;
  }

  void recordCommand(PlayerCommand command) {
    commands.add(CommandRecord(command: command, timestamp: _elapsedTime));
  }

  bool hasCommandBefore(PlayerCommand command, double beforeTime) {
    return commands
        .any((c) => c.command == command && c.timestamp < beforeTime);
  }

  bool hasCommandInWindow(PlayerCommand command, double from, double to) {
    return commands.any(
        (c) => c.command == command && c.timestamp >= from && c.timestamp <= to);
  }

  int countCommand(PlayerCommand command) {
    return commands.where((c) => c.command == command).length;
  }

  List<CommandRecord> getAll() => List.unmodifiable(commands);
}
