import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/services/audio_manager.dart';
import '../../core/services/firebase_service.dart';
import '../widgets/balance_diagnostic_panel.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sfxEnabled = true;
  bool _bgmEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: 'ゲーム設定',
            children: [
              SwitchListTile(
                title: const Text('効果音', style: TextStyle(color: Color(0xFFE8D5B0))),
                subtitle: Text('SE', style: TextStyle(color: Colors.grey[600])),
                value: _sfxEnabled,
                activeThumbColor: const Color(0xFFFFD700),
                onChanged: (v) {
                  setState(() => _sfxEnabled = v);
                  AudioManager().setSeEnabled(v);
                },
              ),
              SwitchListTile(
                title: const Text('BGM', style: TextStyle(color: Color(0xFFE8D5B0))),
                subtitle: Text('バックグラウンドミュージック',
                    style: TextStyle(color: Colors.grey[600])),
                value: _bgmEnabled,
                activeThumbColor: const Color(0xFFFFD700),
                onChanged: (v) {
                  setState(() => _bgmEnabled = v);
                  AudioManager().setBgmEnabled(v);
                  if (!v) {
                    AudioManager().pauseBgm();
                  } else {
                    AudioManager().resumeBgm();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'データ管理',
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_upload, color: Color(0xFFFFD700)),
                title: const Text('クラウドに保存',
                    style: TextStyle(color: Color(0xFFE8D5B0))),
                subtitle: Text('Firebase アカウントが必要です',
                    style: TextStyle(color: Colors.grey[600])),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _showComingSoon(context),
              ),
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: const Text('セーブデータを削除',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () => _confirmDeleteData(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (kDebugMode)
            _Section(
              title: 'デバッグ・バランス調整',
              children: [
                ListTile(
                  leading: const Icon(Icons.balance, color: Colors.orange),
                  title: const Text('バランス診断',
                      style: TextStyle(color: Color(0xFFE8D5B0))),
                  subtitle: const Text('シナリオ毎のバランス分析',
                      style: TextStyle(color: Colors.grey, fontSize: 11)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => _showBalanceDiagnostics(context),
                ),
              ],
            ),
          const SizedBox(height: 16),
          _Section(
            title: 'その他',
            children: [
              ListTile(
                leading: const Icon(Icons.school, color: Colors.grey),
                title: const Text('チュートリアルをもう一度見る',
                    style: TextStyle(color: Color(0xFFE8D5B0))),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => Navigator.pushNamed(context, '/onboarding'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.grey),
                title: const Text('プライバシーポリシー',
                    style: TextStyle(color: Color(0xFFE8D5B0))),
                trailing: const Icon(Icons.open_in_new, color: Colors.grey, size: 16),
                onTap: () => _showComingSoon(context),
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.grey),
                title: const Text('利用規約',
                    style: TextStyle(color: Color(0xFFE8D5B0))),
                trailing: const Icon(Icons.open_in_new, color: Colors.grey, size: 16),
                onTap: () => _showComingSoon(context),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.grey),
                title: const Text('バージョン',
                    style: TextStyle(color: Color(0xFFE8D5B0))),
                trailing: const Text('1.0.0',
                    style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('近日公開')),
    );
  }

  void _showBalanceDiagnostics(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('バランス診断'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(ctx),
            ),
          ),
          body: DefaultTabController(
            length: Scenario.values.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabs: [
                    for (final scenario in Scenario.values)
                      Tab(text: scenario.displayNameJa),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      for (final scenario in Scenario.values)
                        _DifficultySwitcher(scenario: scenario),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteData(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2A1A0A),
        title: const Text('データを削除しますか？',
            style: TextStyle(color: Color(0xFFFFD700))),
        content: const Text('この操作は元に戻せません',
            style: TextStyle(color: Color(0xFFE8D5B0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseService().deleteUserData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('データを削除しました')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('データの削除に失敗しました')),
                  );
                }
              }
            },
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
          _navItem(context, Icons.leaderboard, 'ランキング', '/ranking'),
          _navItem(context, Icons.settings, '設定', '/settings', selected: true),
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

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }
}

/// 難易度別バランス診断スイッチャー
class _DifficultySwitcher extends StatefulWidget {
  final Scenario scenario;

  const _DifficultySwitcher({required this.scenario});

  @override
  State<_DifficultySwitcher> createState() => _DifficultySwitcherState();
}

class _DifficultySwitcherState extends State<_DifficultySwitcher> {
  late DifficultyMode _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = DifficultyMode.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<DifficultyMode>(
            segments: [
              for (final diff in DifficultyMode.values)
                ButtonSegment(
                  value: diff,
                  label: Text(diff.displayName),
                ),
            ],
            selected: {_selectedDifficulty},
            onSelectionChanged: (selection) {
              setState(() {
                _selectedDifficulty = selection.first;
              });
            },
          ),
        ),
        Expanded(
          child: BalanceDiagnosticPanel(
            scenario: widget.scenario,
            difficulty: _selectedDifficulty,
          ),
        ),
      ],
    );
  }
}
