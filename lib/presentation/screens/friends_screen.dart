import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/firebase_service.dart';
import '../../data/repositories/friend_repository.dart';

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

    if (!mounted) return;
    setState(() {
      _myCode = code;
      _friends = friends;
      _ranking = ranking;
      _loading = false;
    });
  }

  Future<void> _addFriend() async {
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
        const SnackBar(content: Text('フレンドを追加しました！')),
      );
    } else {
      setState(() => _errorMessage = 'コードが無効か、既にフレンド登録済みです');
    }
  }

  Future<void> _removeFriend(String friendUserId) async {
    final userId = FirebaseService().userId;
    if (userId == null) return;
    await _friendRepo.removeFriend(userId, friendUserId);
    await _loadData();
  }

  void _shareMyCode() {
    final code = _myCode;
    if (code == null) return;
    SharePlus.instance.share(
      ShareParams(
        text: '戦国采配録で対戦しよう！\nフレンドコード: $code',
      ),
    );
  }

  void _copyMyCode() {
    final code = _myCode;
    if (code == null) return;
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('フレンドコードをコピーしました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myUserId = FirebaseService().userId;

    return Scaffold(
      appBar: AppBar(title: const Text('フレンド')),
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
                  ),
                  const SizedBox(height: 16),
                  _AddFriendCard(
                    controller: _codeController,
                    isLoading: _isAddingFriend,
                    errorMessage: _errorMessage,
                    onSubmit: _addFriend,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'フレンドランキング（合計スコア）',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_ranking.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'まだ戦績がありません',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._ranking.asMap().entries.map(
                          (entry) => _RankingRow(
                            rank: entry.key + 1,
                            entry: entry.value,
                            isMe: entry.value.userId == myUserId,
                          ),
                        ),
                  const SizedBox(height: 24),
                  Text(
                    'フレンド一覧 (${_friends.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_friends.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'まだフレンドがいません',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._friends.map(
                      (friend) => _FriendRow(
                        friend: friend,
                        onRemove: () => _removeFriend(friend.userId),
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

  const _MyCodeCard({
    required this.code,
    required this.onCopy,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B1A1A).withOpacity(0.3),
            const Color(0xFF3B1A1A).withOpacity(0.2),
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
          const Text(
            'あなたのフレンドコード',
            style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  label: const Text('コピー'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('共有'),
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

  const _AddFriendCard({
    required this.controller,
    required this.isLoading,
    required this.errorMessage,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'フレンドを追加',
              style: TextStyle(
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
                    decoration: const InputDecoration(
                      hintText: 'フレンドコードを入力',
                      isDense: true,
                      border: OutlineInputBorder(),
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
                      : const Text('追加'),
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

  const _RankingRow({
    required this.rank,
    required this.entry,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe
              ? const Color(0xFF8B1A1A).withOpacity(0.2)
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
                isMe ? 'あなた' : entry.userId.substring(0, 8),
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

class _FriendRow extends StatelessWidget {
  final FriendInfo friend;
  final VoidCallback onRemove;

  const _FriendRow({required this.friend, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person, color: Color(0xFFFFD700)),
        title: Text(friend.friendCode),
        trailing: IconButton(
          icon: const Icon(Icons.person_remove, color: Colors.grey),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
