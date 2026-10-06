import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/firebase_service.dart';
import '../../data/models/scenario_data.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  static const int _pageSize = 20;

  Scenario? _selectedScenario;
  bool _isGlobal = true;
  final _scrollController = ScrollController();

  // グローバルランキング（ページネーション対応）
  final List<RankingEntry> _globalRankings = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMoreGlobal = true;
  bool _isLoadingGlobal = false;
  bool _globalLoadFailed = false;

  // マイプレイ（件数が少ないため単発取得のまま）
  Future<List<RankingEntry>>? _userRankingFuture;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRankings();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isGlobal || _isLoadingGlobal || !_hasMoreGlobal) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreGlobalRankings();
    }
  }

  void _loadRankings() {
    if (_isGlobal) {
      setState(() {
        _globalRankings.clear();
        _lastDocument = null;
        _hasMoreGlobal = true;
        _globalLoadFailed = false;
      });
      _loadMoreGlobalRankings();
    } else {
      setState(() {
        _userRankingFuture = FirebaseService().getUserRankings();
      });
    }
  }

  Future<void> _loadMoreGlobalRankings() async {
    if (_isLoadingGlobal || !_hasMoreGlobal) return;
    setState(() => _isLoadingGlobal = true);

    final page = await FirebaseService().getGlobalRankingsPage(
      scenarioId: _selectedScenario?.name,
      limit: _pageSize,
      startAfter: _lastDocument,
      rankOffset: _globalRankings.length,
    );

    if (!mounted) return;
    setState(() {
      _globalRankings.addAll(page.entries);
      _lastDocument = page.lastDocument;
      _hasMoreGlobal = page.hasMore;
      _isLoadingGlobal = false;
      _globalLoadFailed = page.entries.isEmpty && _globalRankings.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ランキング'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'ランキングを共有',
            onPressed: () => SharePlus.instance.share(
              ShareParams(
                text: '戦国采配録でランキングに挑戦中！あなたも采配を振るってみない？\n'
                    '#戦国采配録',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRankings,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(label: Text('グローバル'), value: true),
                      ButtonSegment(label: Text('マイプレイ'), value: false),
                    ],
                    selected: {_isGlobal},
                    onSelectionChanged: (newSelection) {
                      setState(() => _isGlobal = newSelection.first);
                      _loadRankings();
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_isGlobal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<Scenario?>(
                value: _selectedScenario,
                isExpanded: true,
                hint: const Text('全シナリオ'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('全シナリオ')),
                  ...Scenario.values.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.displayNameJa),
                      )),
                ],
                onChanged: (scenario) {
                  setState(() => _selectedScenario = scenario);
                  _loadRankings();
                },
              ),
            ),
          Expanded(
            child: _isGlobal ? _buildGlobalRankingList() : _buildUserRankingList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildGlobalRankingList() {
    if (_globalLoadFailed) {
      return const Center(child: Text('エラーが発生しました'));
    }
    if (_globalRankings.isEmpty && _isLoadingGlobal) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_globalRankings.isEmpty) {
      return const Center(child: Text('ランキングデータはまだありません'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _globalRankings.length + (_hasMoreGlobal ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _globalRankings.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final entry = _globalRankings[index];
        return _RankingCard(entry: entry, index: index);
      },
    );
  }

  Widget _buildUserRankingList() {
    return FutureBuilder<List<RankingEntry>>(
      future: _userRankingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              snapshot.hasError ? 'エラーが発生しました' : 'ランキングデータはまだありません',
            ),
          );
        }

        final rankings = snapshot.data!;
        return ListView.builder(
          itemCount: rankings.length,
          itemBuilder: (context, index) {
            final entry = rankings[index];
            return _RankingCard(entry: entry, index: index);
          },
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF8B6914))),
        color: Color(0xFF2A1A0A),
      ),
      child: Row(
        children: [
          _navItem(context, Icons.home, 'ホーム', '/home'),
          _navItem(context, Icons.leaderboard, 'ランキング', '/ranking',
              selected: true),
          _navItem(context, Icons.settings, '設定', '/settings'),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, String route,
      {bool selected = false}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (!selected) Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? const Color(0xFFFFD700) : Colors.grey),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? const Color(0xFFFFD700) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankingCard extends StatelessWidget {
  final RankingEntry entry;
  final int index;

  const _RankingCard({required this.entry, required this.index});

  @override
  Widget build(BuildContext context) {
    final isTopThree = index < 3;
    final medalColors = [
      const Color(0xFFFFD700),
      const Color(0xFFC0C0C0),
      const Color(0xFFCD7F32),
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (isTopThree)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: medalColors[index],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: 36,
                child: Text(
                  '${index + 1}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.userId,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (entry.won)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '勝利',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.duration}秒',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${entry.score.toString().replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]},',
                        )} pt',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
