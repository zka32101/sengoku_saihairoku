import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/scenario_data.dart';
import '../../data/repositories/friend_repository.dart';
import '../../data/repositories/friend_challenge_repository.dart';
import '../../l10n/generated/app_localizations.dart';

/// フレンド管理画面：自分のフレンドコード表示・共有、
/// フレンド追加、フレンド限定ランキング表示
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendRepository _friendRepo = FriendRepository();
  final TextEditingController _codeController = TextEditingController();

  String? _myCode;
  List<FriendInfo> _friends = [];
  List<FriendRankingEntry> _ranking = [];
  List<FriendActivityEntry> _activity = [];
  bool _loading = true;
  bool _isAddingFriend = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final userId = FirebaseService().userId;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }

    final code = await _friendRepo.getOrCreateMyFriendCode(userId);
    final friends = await _friendRepo.getFriends(userId);
    final ranking = await _friendRepo.getFriendsRanking(userId);
    final activity = await _friendRepo.getFriendsActivity(userId);

    if (!mounted) return;
    setState(() {
      _myCode = code;
      _friends = friends;
      _ranking = ranking;
      _activity = activity;
      _loading = false;
    });
  }

  /// アクティビティフィード表示用：userIdからフレンドコードを解決する
  /// （自分自身はnullを返し、呼び出し側で「あなた」と表示させる）
  String? _friendCodeFor(String userId) {
    if (userId == FirebaseService().userId) return null;
    for (final friend in _friends) {
      if (friend.userId == userId) return friend.friendCode;
    }
    return null;
  }

  Future<void> _addFriend() async {
    final l10n = AppLocalizations.of(context)!;
    final userId = FirebaseService().userId;
    final code = _codeController.text.trim();
    if (userId == null || code.isEmpty) return;

    setState(() {
      _isAddingFriend = true;
      _errorMessage = null;
    });

    final success = await _friendRepo.addFriendByCode(userId, code);

    if (!mounted) return;
    setState(() => _isAddingFriend = false);

    if (success) {
      _codeController.clear();
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.friendsAddedSuccess)),
      );
    } else {
      setState(() => _errorMessage = l10n.friendsAddFailed);
    }
  }

  Future<void> _removeFriend(String friendUserId) async {
    final userId = FirebaseService().userId;
    if (userId == null) return;
    await _friendRepo.removeFriend(userId, friendUserId);
    await _loadData();
  }

  Future<void> _challengeFriend(FriendInfo friend) async {
    final l10n = AppLocalizations.of(context)!;
    final scenario = await showDialog<Scenario>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.friendsChallengeScenarioTitle),
        children: Scenario.values
            .map((s) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(ctx, s),
                  child: Text(s.displayNameJa),
                ))
            .toList(),
      ),
    );
    if (scenario == null || !mounted) return;

    final bestScore =
        await _friendRepo.getFriendBestScore(friend.userId, scenario.name);
    if (!mounted) return;

    if (bestScore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.friendsNoRecordYet)),
      );
      return;
    }

    await FriendChallengeRepository().setChallenge(
      FriendChallengeTarget(
        friendUserId: friend.userId,
        friendLabel: friend.friendCode,
        scenario: scenario,
        targetScore: bestScore,
      ),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.friendsChallengeSetMessage(
              friend.friendCode, scenario.displayNameJa, bestScore),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _shareMyCode() {
    final l10n = AppLocalizations.of(context)!;
    final code = _myCode;
    if (code == null) return;
    SharePlus.instance.share(
      ShareParams(
        text: l10n.friendsShareMyCodeText(code),
      ),
    );
  }

  void _copyMyCode() {
    final l10n = AppLocalizations.of(context)!;
    final code = _myCode;
    if (code == null) return;
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.friendsCopySuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final myUserId = FirebaseService().userId;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.friendsTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _MyCodeCard(
                    code: _myCode ?? '----',
                    onCopy: _copyMyCode,
                    onShare: _shareMyCode,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 16),
                  _AddFriendCard(
                    controller: _codeController,
                    isLoading: _isAddingFriend,
                    errorMessage: _errorMessage,
                    onSubmit: _addFriend,
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.friendsRankingTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_ranking.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.friendsNoRecordsYet,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._ranking.asMap().entries.map(
                          (entry) => _RankingRow(
                            rank: entry.key + 1,
                            entry: entry.value,
                            isMe: entry.value.userId == myUserId,
                            l10n: l10n,
                          ),
                        ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.friendsRecentActivityTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_activity.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.friendsNoRecordsYet,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._activity.map(
                      (entry) => _ActivityRow(
                        entry: entry,
                        friendCode: _friendCodeFor(entry.userId),
                        l10n: l10n,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.friendsListTitle(_friends.length),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_friends.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          l10n.friendsNoFriendsYet,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._friends.map(
                      (friend) => _FriendRow(
                        friend: friend,
                        onRemove: () => _removeFriend(friend.userId),
                        onChallenge: () => _challengeFriend(friend),
                        l10n: l10n,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _MyCodeCard extends StatelessWidget {
  final String code;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final AppLocalizations l10n;

  const _MyCodeCard({
    required this.code,
    required this.onCopy,
    required this.onShare,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B1A1A).withValues(alpha: 0.3),
            const Color(0xFF3B1A1A).withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xFFFFD700), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.friendsMyCodeLabel,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy, size: 18),
                  label: Text(l10n.friendsCopyButton),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share, size: 18),
                  label: Text(l10n.friendsShareButton),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddFriendCard extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final AppLocalizations l10n;

  const _AddFriendCard({
    required this.controller,
    required this.isLoading,
    required this.errorMessage,
    required this.onSubmit,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.friendsAddFriendTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE8D5B0),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: l10n.friendsCodeHint,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isLoading ? null : onSubmit,
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.friendsAddButton),
                ),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  final int rank;
  final FriendRankingEntry entry;
  final bool isMe;
  final AppLocalizations l10n;

  const _RankingRow({
    required this.rank,
    required this.entry,
    required this.isMe,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFF8B1A1A).withValues(alpha: 0.2)
              : const Color(0xFF2A1A0A),
          border: isMe
              ? Border.all(color: const Color(0xFFFFD700), width: 1)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
            ),
            Expanded(
              child: Text(
                isMe ? l10n.friendsYouLabel : entry.userId.substring(0, 8),
                style: const TextStyle(color: Color(0xFFE8D5B0)),
              ),
            ),
            Text(
              '${entry.totalScore} pts',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final FriendActivityEntry entry;
  final String? friendCode; // nullなら自分自身
  final AppLocalizations l10n;

  const _ActivityRow({
    required this.entry,
    required this.friendCode,
    required this.l10n,
  });

  String get _scenarioLabel {
    try {
      return Scenario.values.byName(entry.scenarioId).displayNameJa;
    } catch (_) {
      return entry.scenarioId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final playerLabel = friendCode ?? l10n.friendsYouLabel;
    final minutesAgo = DateTime.now().difference(entry.playedAt).inMinutes;
    final timeLabel = minutesAgo < 60
        ? l10n.statisticsTimeMinutesAgo(minutesAgo)
        : l10n.statisticsTimeMonthDay(entry.playedAt.month, entry.playedAt.day);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          entry.won ? Icons.emoji_events : Icons.close,
          color: entry.won ? Colors.amber : Colors.grey,
        ),
        title: Text(l10n.friendsActivityLine(
          playerLabel,
          _scenarioLabel,
          entry.won ? l10n.chainBattleWin : l10n.chainBattleLoss,
        )),
        subtitle: Text(timeLabel, style: const TextStyle(fontSize: 12)),
        trailing: Text(
          '${entry.score} pt',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyan),
        ),
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  final FriendInfo friend;
  final VoidCallback onRemove;
  final VoidCallback onChallenge;
  final AppLocalizations l10n;

  const _FriendRow({
    required this.friend,
    required this.onRemove,
    required this.onChallenge,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person, color: Color(0xFFFFD700)),
        title: Text(friend.friendCode),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.sports_kabaddi, color: Color(0xFFFFD700)),
              tooltip: l10n.friendsChallengeTooltip,
              onPressed: onChallenge,
            ),
            IconButton(
              icon: const Icon(Icons.person_remove, color: Colors.grey),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
