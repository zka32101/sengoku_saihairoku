import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/battle_replay.dart';
import '../../data/models/difficulty_mode.dart';
import '../../data/repositories/replay_repository.dart';
import '../../data/repositories/shared_replay_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../widgets/replay_player.dart';

/// リプレイ一覧・再生画面
class ReplayScreen extends StatefulWidget {
  const ReplayScreen({super.key});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  final _replayRepo = ReplayRepository();
  final _sharedReplayRepo = SharedReplayRepository();
  late Future<List<BattleReplay>> _replays;
  late Future<ReplayStats> _stats;
  int _selectedFilter = 0; // 0=全部, 1=勝利, 2=敗北

  @override
  void initState() {
    super.initState();
    _loadReplays();
  }

  void _loadReplays() {
    _replays = _getFilteredReplays();
    _stats = _replayRepo.getStats();
    setState(() {});
  }

  Future<List<BattleReplay>> _getFilteredReplays() async {
    switch (_selectedFilter) {
      case 1:
        return _replayRepo.getVictoryReplays();
      case 2:
        return _replayRepo.getDefeatReplays();
      default:
        return _replayRepo.getAllReplays();
    }
  }

  void _deleteReplay(String id) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.replayDeleteConfirmTitle),
        content: Text(l10n.replayDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              _replayRepo.deleteReplay(id);
              Navigator.pop(ctx);
              _loadReplays();
            },
            child: Text(l10n.replayDeleteButton, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _shareReplay(BattleReplay replay) async {
    final l10n = AppLocalizations.of(context)!;
    final userId = FirebaseService().userId;
    if (userId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(l10n.replayShareIssuingCode),
          ],
        ),
      ),
    );

    try {
      final code = await _sharedReplayRepo.shareReplay(replay, userId);
      if (!mounted) return;
      Navigator.pop(context); // 発行中ダイアログを閉じる

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.replayShareCodeTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                code,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.replayShareCodeHint),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.commonClose),
            ),
            TextButton(
              onPressed: () {
                SharePlus.instance.share(ShareParams(
                  text: l10n.replayShareText(code),
                ));
              },
              child: Text(l10n.replayShareButton),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.replayShareFailure(e.toString()))),
      );
    }
  }

  void _showCodeEntryDialog() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.replayCodeEntryTitle),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          maxLength: 6,
          decoration: InputDecoration(hintText: l10n.replayCodeEntryHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              final code = controller.text.trim();
              Navigator.pop(ctx);
              if (code.isEmpty) return;
              await _viewSharedReplay(code);
            },
            child: Text(l10n.replayWatchButton),
          ),
        ],
      ),
    );
  }

  Future<void> _viewSharedReplay(String code) async {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(l10n.replayFetchingReplay),
          ],
        ),
      ),
    );

    final replay = await _sharedReplayRepo.getReplayByCode(code);
    if (!mounted) return;
    Navigator.pop(context); // 取得中ダイアログを閉じる

    if (replay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.replayNotFound)),
      );
      return;
    }

    _showReplayPlayer(replay, sharedCode: code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeReplayTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            tooltip: l10n.replayWatchSharedTooltip,
            onPressed: _showCodeEntryDialog,
          ),
        ],
      ),
      body: FutureBuilder<List<BattleReplay>>(
        future: _replays,
        builder: (context, replaySnapshot) {
          if (!replaySnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final replays = replaySnapshot.data!;

          return CustomScrollView(
            slivers: [
              // 統計情報
              SliverToBoxAdapter(
                child: FutureBuilder<ReplayStats>(
                  future: _stats,
                  builder: (context, statsSnapshot) {
                    if (!statsSnapshot.hasData) {
                      return const SizedBox();
                    }

                    final stats = statsSnapshot.data!;
                    return _ReplayStatsCard(stats: stats, l10n: l10n);
                  },
                ),
              ),

              // フィルタータブ
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: l10n.replayFilterAll,
                        selected: _selectedFilter == 0,
                        onTap: () {
                          setState(() => _selectedFilter = 0);
                          _loadReplays();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: l10n.chainBattleWin,
                        selected: _selectedFilter == 1,
                        color: Colors.green,
                        onTap: () {
                          setState(() => _selectedFilter = 1);
                          _loadReplays();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: l10n.chainBattleLoss,
                        selected: _selectedFilter == 2,
                        color: Colors.red,
                        onTap: () {
                          setState(() => _selectedFilter = 2);
                          _loadReplays();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 8)),

              // リプレイ一覧
              if (replays.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.replayEmptyMessage,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final replay = replays[index];
                      return _ReplayListTile(
                        replay: replay,
                        onTap: () => _showReplayPlayer(replay),
                        onDelete: () => _deleteReplay(replay.id),
                        onShare: () => _shareReplay(replay),
                        l10n: l10n,
                      );
                    },
                    childCount: replays.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showReplayPlayer(BattleReplay replay, {String? sharedCode}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                if (sharedCode != null)
                  _ReplayLikeBar(
                    code: sharedCode,
                    repo: _sharedReplayRepo,
                  ),
                ReplayPlayer(replay: replay),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 共有コードで観戦中のリプレイに「いいね」とコメントを送るバー
class _ReplayLikeBar extends StatefulWidget {
  final String code;
  final SharedReplayRepository repo;

  const _ReplayLikeBar({required this.code, required this.repo});

  @override
  State<_ReplayLikeBar> createState() => _ReplayLikeBarState();
}

class _ReplayLikeBarState extends State<_ReplayLikeBar> {
  int? _likeCount;
  bool _liked = false;
  bool _loading = false;
  List<ReplayComment> _comments = [];
  final _commentController = TextEditingController();
  bool _postingComment = false;

  @override
  void initState() {
    super.initState();
    widget.repo.getLikeCount(widget.code).then((count) {
      if (mounted) setState(() => _likeCount = count);
    });
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    final comments = await widget.repo.getComments(widget.code);
    if (mounted) setState(() => _comments = comments);
  }

  Future<void> _onLike() async {
    if (_liked || _loading) return;
    setState(() => _loading = true);
    final count = await widget.repo.likeReplay(widget.code);
    if (!mounted) return;
    setState(() {
      _likeCount = count;
      _liked = true;
      _loading = false;
    });
  }

  Future<void> _onPostComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _postingComment) return;

    final userId = FirebaseService().userId;
    if (userId == null) return;

    setState(() => _postingComment = true);
    await widget.repo.postComment(widget.code, userId, text);
    _commentController.clear();
    await _loadComments();
    if (mounted) setState(() => _postingComment = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _onLike,
                icon: Icon(
                  _liked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
              ),
              Text(_likeCount == null
                  ? '...'
                  : l10n.replayLikeCountSuffix(_likeCount!)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  maxLength: 140,
                  decoration: InputDecoration(
                    hintText: l10n.replayCommentHint,
                    isDense: true,
                    counterText: '',
                  ),
                ),
              ),
              IconButton(
                onPressed: _postingComment ? null : _onPostComment,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          for (final comment in _comments)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                comment.text,
                style: const TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

/// リプレイ統計カード
class _ReplayStatsCard extends StatelessWidget {
  final ReplayStats stats;
  final AppLocalizations l10n;

  const _ReplayStatsCard({required this.stats, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.replayStatsTotalLabel,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '${stats.totalReplays}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.replayStatsWinRateLabel,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.winRate}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.replayStatsAverageScoreLabel,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.averageScore}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.replayStatsWinLossLabel,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.victories}W/${stats.defeats}L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// フィルターチップ
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      backgroundColor: Colors.grey[200],
      selectedColor: color ?? Colors.blue,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => onTap(),
    );
  }
}

/// リプレイリスト項目
class _ReplayListTile extends StatelessWidget {
  final BattleReplay replay;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final AppLocalizations l10n;

  const _ReplayListTile({
    required this.replay,
    required this.onTap,
    required this.onDelete,
    required this.onShare,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: replay.isVictory ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              replay.isVictory ? '🏆' : '💔',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(replay.battleName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              l10n.replayDifficultyScoreLine(
                  replay.difficulty.displayName, replay.finalScore),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              replay.playedAt.toString().split(' ')[0],
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (ctx) => [
            PopupMenuItem(
              onTap: onShare,
              child: Text(l10n.replayShareMenuItem),
            ),
            PopupMenuItem(
              onTap: onDelete,
              child: Text(l10n.replayDeleteButton),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
