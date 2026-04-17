import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mock_tts_flutter/core/constants/app_constants.dart';
import 'package:mock_tts_flutter/features/tts/presentation/providers/tts_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final defaultVoice = ref.watch(defaultVoiceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.dark_mode_rounded,
                iconColor: const Color(0xFF6C3CE1),
                title: 'Dark Mode',
                subtitle: isDarkMode ? 'On' : 'Off',
                trailing: Switch.adaptive(
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(isDarkModeProvider.notifier).state = value;
                  },
                  activeTrackColor: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Voice Section
          _SectionHeader(title: 'Default Voice'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.record_voice_over_rounded,
                iconColor: const Color(0xFF00D2C8),
                title: 'Voice',
                subtitle: AppConstants.voices
                    .firstWhere((v) => v.id == defaultVoice)
                    .displayName,
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showVoicePicker(context, ref, defaultVoice),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About Section
          _SectionHeader(title: 'About'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF4A90D9),
                title: 'Version',
                subtitle: '1.0.0 (Mock)',
              ),
              Divider(
                height: 1,
                color: colorScheme.onSurface.withValues(alpha: 0.06),
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFFE67E22),
                title: 'Terms of Service',
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () {},
              ),
              Divider(
                height: 1,
                color: colorScheme.onSurface.withValues(alpha: 0.06),
              ),
              _SettingsTile(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF27AE60),
                title: 'Privacy Policy',
                trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Usage Stats (Dummy Analytics)
          _SectionHeader(title: 'Usage Statistics'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _StatsTile(
                icon: Icons.auto_awesome_rounded,
                label: 'Total Generations',
                value: '24',
                color: colorScheme.primary,
              ),
              Divider(
                height: 1,
                color: colorScheme.onSurface.withValues(alpha: 0.06),
              ),
              _StatsTile(
                icon: Icons.text_fields_rounded,
                label: 'Characters Processed',
                value: '12,450',
                color: const Color(0xFF00D2C8),
              ),
              Divider(
                height: 1,
                color: colorScheme.onSurface.withValues(alpha: 0.06),
              ),
              _StatsTile(
                icon: Icons.timer_rounded,
                label: 'Audio Generated',
                value: '18 min',
                color: const Color(0xFFE67E22),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Sign Out
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _showVoicePicker(BuildContext context, WidgetRef ref, String current) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Default Voice',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ...AppConstants.voices.map((voice) {
                final isSelected = voice.id == current;
                return ListTile(
                  onTap: () {
                    ref.read(defaultVoiceProvider.notifier).state = voice.id;
                    Navigator.pop(context);
                  },
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? colorScheme.primary
                        : colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person_rounded,
                      color: isSelected
                          ? Colors.white
                          : colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    voice.displayName,
                    style: GoogleFonts.inter(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_rounded, color: colorScheme.primary)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            )
          : null,
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _StatsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatsTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
