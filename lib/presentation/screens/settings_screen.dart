import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/services/audio_manager.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/locale_controller.dart';
import '../../core/services/message_settings.dart';
import '../../l10n/generated/app_localizations.dart';
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
  bool _storyMessagesEnabled = MessageSettings().storyMessagesEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: l10n.settingsGameSection,
            children: [
              SwitchListTile(
                title: Text(l10n.settingsSfx, style: const TextStyle(color: Color(0xFFE8D5B0))),
                subtitle: Text(l10n.settingsSfxSubtitle, style: TextStyle(color: Colors.grey[600])),
                value: _sfxEnabled,
                activeThumbColor: const Color(0xFFFFD700),
                onChanged: (v) {
                  setState(() => _sfxEnabled = v);
                  AudioManager().setSeEnabled(v);
                },
              ),
              SwitchListTile(
                title: Text(l10n.settingsBgm, style: const TextStyle(color: Color(0xFFE8D5B0))),
                subtitle: Text(l10n.settingsBgmSubtitle,
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
              SwitchListTile(
                title: Text(l10n.settingsStoryMessages,
                    style: const TextStyle(color: Color(0xFFE8D5B0))),
                subtitle: Text(l10n.settingsStoryMessagesSubtitle,
                    style: TextStyle(color: Colors.grey[600])),
                value: _storyMessagesEnabled,
                activeThumbColor: const Color(0xFFFFD700),
                onChanged: (v) {
                  setState(() => _storyMessagesEnabled = v);
                  MessageSettings().setStoryMessagesEnabled(v);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: l10n.settingsLanguageSection,
            children: [
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFFFFD700)),
                title: Text(l10n.settingsDisplayLanguage,
                    style: const TextStyle(color: Color(0xFFE8D5B0))),
                trailing: ValueListenableBuilder<Locale?>(
                  valueListenable: LocaleController.instance,
                  builder: (context, locale, _) {
                    return DropdownButton<String>(
                      value: locale?.languageCode ?? 'system',
                      dropdownColor: const Color(0xFF2A1A0A),
                      underline: const SizedBox.shrink(),
                      items: [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text(l10n.settingsLanguageSystem,
                              style: const TextStyle(color: Color(0xFFE8D5B0))),
                        ),
                        DropdownMenuItem(
                          value: 'ja',
                          child: Text(l10n.settingsLanguageJa,
                              style: const TextStyle(color: Color(0xFFE8D5B0))),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(l10n.settingsLanguageEn,
                              style: const TextStyle(color: Color(0xFFE8D5B0))),
                        ),
                      ],
                      onChanged: (value) {
                        LocaleController.instance.setLocale(
                          value == null || value == 'system'
                              ? null
                              : Locale(value),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: l10n.settingsDataSection,
            children: [
              ListTile(
                leading: const Icon(Icons.cloud_upload, color: Color(0xFFFFD700)),
                title: Text(l10n.settingsCloudSave,
                    style: const TextStyle(color: Color(0xFFE8D5B0))),
                subtitle: Text(l10n.settingsCloudSaveSubtitle,
                    style: TextStyle(color: Colors.grey[600])),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => _showComingSoon(context),
              ),
              ListTile(
                leading:
                    const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: Text(l10n.settingsDeleteSaveData,
                    style: const TextStyle(color: Colors.redAccent)),
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
            title: l10n.settingsOtherSection,
            children: [
              ListTile(
                leading: const Icon(Icons.school, color: Colors.grey),
                title: Text(l10n.settingsReplayTutorial,
                    style: const TextStyle(color: Color(0xFFE8D5B0))),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () => Navigator.pushNamed(context, '/onboarding'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip, color: Colors.grey),
                title: Text(l10n.settingsPrivacyPolicy,
                    style: const TextStyle(color: Color(0xFFE8D5B0))),
                trailing: const Icon(Icons.open_in_new, color: Colors.grey, size: 16),
                onTap: () => _showComingSoon(context),
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.grey),
                title: Text(l10n.settingsTermsOfService,
                    style: const TextStyle(color: Color(0xFFE8D5B0))),
                trailing: const Icon(Icons.open_in_new, color: Colors.grey, size: 16),
                onTap: () => _showComingSoon(context),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.grey),
                title: Text(l10n.settingsVersion,
                    style: const TextStyle(color: Color(0xFFE8D5B0))),
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
      SnackBar(content: Text(AppLocalizations.of(context)!.settingsComingSoon)),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2A1A0A),
        title: Text(l10n.settingsDeleteDataTitle,
            style: const TextStyle(color: Color(0xFFFFD700))),
        content: Text(l10n.settingsDeleteDataBody,
            style: const TextStyle(color: Color(0xFFE8D5B0))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await FirebaseService().deleteUserData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.settingsDeleteDataSuccess)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.settingsDeleteDataFailure)),
                  );
                }
              }
            },
            child: Text(l10n.settingsDeleteDataConfirm,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF8B6914))),
        color: Color(0xFF2A1A0A),
      ),
      child: Row(
        children: [
          _navItem(context, Icons.home, l10n.navHome, '/home'),
          _navItem(context, Icons.leaderboard, l10n.navRanking, '/ranking'),
          _navItem(context, Icons.settings, l10n.navSettings, '/settings', selected: true),
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
