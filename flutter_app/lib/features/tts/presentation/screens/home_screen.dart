import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mock_tts_flutter/core/constants/app_constants.dart';
import 'package:mock_tts_flutter/features/tts/presentation/providers/tts_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedVoice = ref.watch(selectedVoiceProvider);
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final speed = ref.watch(selectedSpeedProvider);
    final generationState = ref.watch(ttsGenerationProvider);

    // Handle generation success
    ref.listen<TTSGenerationState>(ttsGenerationProvider, (prev, next) {
      if (next.status == TTSGenerationStatus.success && next.result != null) {
        final generatedAudioId = next.result!.id;
        
        // Show options bottom sheet instead of immediate navigation
        showModalBottomSheet(
          context: context,
          backgroundColor: colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => _buildPostGenerationOptions(context, generatedAudioId),
        );
        ref.read(ttsGenerationProvider.notifier).reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.record_voice_over_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Nova Voice',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Create Speech',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Enter your text and customize the voice settings',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),

            // Text Input Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 6,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: 'Type or paste your text here...',
                      hintStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                      counterStyle: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: 16, height: 1.5),
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_textController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            _textController.clear();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          iconSize: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Voice Settings
            _buildSectionTitle('Voice Settings', Icons.tune_rounded),
            const SizedBox(height: 12),

            // Voice Dropdown
            _buildDropdownCard(
              label: 'Voice',
              icon: Icons.person_rounded,
              child: DropdownButtonFormField<String>(
                initialValue: selectedVoice,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                items: AppConstants.voices.map((voice) {
                  return DropdownMenuItem(
                    value: voice.id,
                    child: Text(
                      voice.displayName,
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(selectedVoiceProvider.notifier).state = value;
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Language Dropdown
            _buildDropdownCard(
              label: 'Language',
              icon: Icons.language_rounded,
              child: DropdownButtonFormField<String>(
                initialValue: selectedLanguage,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                items: AppConstants.languages.map((lang) {
                  return DropdownMenuItem(
                    value: lang.code,
                    child: Text(
                      lang.name,
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(selectedLanguageProvider.notifier).state = value;
                  }
                },
              ),
            ),
            const SizedBox(height: 12),

            // Speed Slider
            _buildDropdownCard(
              label: 'Speed: ${speed.toStringAsFixed(1)}x',
              icon: Icons.speed_rounded,
              child: Slider(
                value: speed,
                min: 0.5,
                max: 2.0,
                divisions: 6,
                label: '${speed.toStringAsFixed(1)}x',
                onChanged: (value) {
                  ref.read(selectedSpeedProvider.notifier).state = value;
                },
              ),
            ),
            const SizedBox(height: 32),

            // Generate Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: _textController.text.isNotEmpty
                          ? [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.2 + (_pulseController.value * 0.15),
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : null,
                    ),
                    child: child,
                  );
                },
                child: ElevatedButton.icon(
                  onPressed:
                      (generationState.status ==
                              TTSGenerationStatus.generating ||
                          _textController.text.trim().isEmpty)
                      ? null
                      : () {
                          ref
                              .read(ttsGenerationProvider.notifier)
                              .generateSpeech(
                                text: _textController.text.trim(),
                                voice: selectedVoice,
                                language: selectedLanguage,
                                speed: speed,
                              );
                        },
                  icon: generationState.status == TTSGenerationStatus.generating
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome_rounded, size: 22),
                  label: Text(
                    generationState.status == TTSGenerationStatus.generating
                        ? 'Generating...'
                        : 'Generate Speech',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Character count and info
            Center(
              child: Text(
                '${_textController.text.length}/500 characters',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildDropdownCard({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  Widget _buildPostGenerationOptions(BuildContext context, String audioId) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Speech Generated Successfully!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                context.push('/player/$audioId');
              },
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow_rounded, color: colorScheme.primary),
              ),
              title: Text(
                'Preview / Listen to Audio',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Open player to hear the result',
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                // Simulate download for now
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Audio downloaded to device successfully!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.download_rounded, color: colorScheme.secondary),
              ),
              title: Text(
                'Download Audio',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Save to your device storage',
                style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
