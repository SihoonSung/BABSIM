import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool expirationAlerts = true;
  bool recipeSuggestions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SettingsSectionTitle('NOTIFICATIONS'),
          _SwitchRow(
            label: 'Expiration Alerts',
            value: expirationAlerts,
            onChanged: (v) => setState(() => expirationAlerts = v),
          ),
          _SwitchRow(
            label: 'Recipe Suggestions',
            value: recipeSuggestions,
            onChanged: (v) => setState(() => recipeSuggestions = v),
          ),
          const _SettingsSectionTitle('PREFERENCES'),
          const _ActionRow(label: 'Measurement Units', value: 'Metric'),
          const _ActionRow(label: 'Language', value: 'Korean'),
          const _SettingsSectionTitle('DATA & PRIVACY'),
          const _ActionRow(label: 'Privacy Policy'),
          const _ActionRow(label: 'Clear Cache'),
          const _SettingsSectionTitle('ABOUT'),
          const _ActionRow(label: 'Help & Support'),
          const _ActionRow(
            label: 'Version',
            value: '1.0.0',
            showChevron: false,
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String title;

  const _SettingsSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF8EA0BD),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(label, style: const TextStyle(color: Color(0xFF1E2839))),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFFF09154),
          activeTrackColor: const Color(0xFFFFC49E),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String label;
  final String? value;
  final bool showChevron;

  const _ActionRow({required this.label, this.value, this.showChevron = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(label, style: const TextStyle(color: Color(0xFF1E2839))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null)
              Text(value!, style: const TextStyle(color: Color(0xFF8EA0BD))),
            if (showChevron) const SizedBox(width: 8),
            if (showChevron)
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFB7C3D8)),
          ],
        ),
      ),
    );
  }
}
