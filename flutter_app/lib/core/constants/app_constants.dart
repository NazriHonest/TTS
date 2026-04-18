class AppConstants {
  static const String appName = 'Nova Voice';
  static const String appTagline = 'Transform text into lifelike speech';
  static const String apiBaseUrl =
      'http://10.0.2.2:8000/api'; // Android emulator localhost

  static const List<VoiceOption> voices = [
    VoiceOption(id: 'female_1', name: 'Ubah', gender: 'Female', accent: 'SO'),
    VoiceOption(id: 'male_1', name: 'Musse', gender: 'Male', accent: 'US'),
    VoiceOption(id: 'female_2', name: 'Nasra', gender: 'Female', accent: 'UK'),
    VoiceOption(id: 'male_2', name: 'Nasri', gender: 'Male', accent: 'ES'),
  ];

  static const List<LanguageOption> languages = [
    LanguageOption(code: 'so-SO', name: 'Somali'),
    LanguageOption(code: 'ar-SA', name: 'Arabic'),
    LanguageOption(code: 'sw-KE', name: 'Swahili'),
    LanguageOption(code: 'en-US', name: 'English (US)'),
    LanguageOption(code: 'en-GB', name: 'English (UK)'),
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

  const LanguageOption({required this.code, required this.name});
}
