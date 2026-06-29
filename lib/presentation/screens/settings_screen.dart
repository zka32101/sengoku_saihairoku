import 'package:flutter/material.dart';
import '../../core/services/audio_manager.dart';

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
          _Section(
            title: 'その他',
            children: [
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('データを削除しました')),
              );
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
