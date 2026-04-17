class AppConstants {
  static const String appName = 'VoxAI';
  static const String appTagline = 'Transform text into lifelike speech';
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api'; // Android emulator localhost

  static const List<VoiceOption> voices = [
    VoiceOption(id: 'female_1', name: 'Sarah', gender: 'Female', accent: 'US'),
    VoiceOption(id: 'male_1', name: 'James', gender: 'Male', accent: 'US'),
    VoiceOption(id: 'female_2', name: 'Emma', gender: 'Female', accent: 'UK'),
    VoiceOption(id: 'male_2', name: 'Carlos', gender: 'Male', accent: 'ES'),
    VoiceOption(id: 'female_3', name: 'Yuki', gender: 'Female', accent: 'JP'),
    VoiceOption(id: 'male_3', name: 'Hans', gender: 'Male', accent: 'DE'),
  ];

  static const List<LanguageOption> languages = [
    LanguageOption(code: 'en-US', name: 'English (US)'),
    LanguageOption(code: 'en-GB', name: 'English (UK)'),
    LanguageOption(code: 'es-ES', name: 'Spanish'),
    LanguageOption(code: 'fr-FR', name: 'French'),
    LanguageOption(code: 'de-DE', name: 'German'),
    LanguageOption(code: 'ja-JP', name: 'Japanese'),
  ];

  static const String sampleAudioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
}

class VoiceOption {
  final String id;
  final String name;
  final String gender;
  final String accent;

  const VoiceOption({
    required this.id,
    required this.name,
    required this.gender,
    required this.accent,
  });

  String get displayName => '$name ($gender · $accent)';
}

class LanguageOption {
  final String code;
  final String name;

  const LanguageOption({
    required this.code,
    required this.name,
  });
}
