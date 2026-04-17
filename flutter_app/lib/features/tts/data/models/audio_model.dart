class AudioModel {
  final String id;
  final String text;
  final String audioUrl;
  final String voice;
  final String language;
  final double speed;
  final DateTime createdAt;
  final bool isFavorite;

  AudioModel({
    required this.id,
    required this.text,
    required this.audioUrl,
    required this.voice,
    required this.language,
    required this.speed,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      id: json['id'] as String,
      text: json['text'] as String,
      audioUrl: json['audio_url'] as String,
      voice: json['voice'] as String,
      language: json['language'] ?? 'en-US',
      speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
      createdAt: DateTime.tryParse(json['created_at'] as String) ?? DateTime.now(),
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'audio_url': audioUrl,
      'voice': voice,
      'language': language,
      'speed': speed,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }

  AudioModel copyWith({
    String? id,
    String? text,
    String? audioUrl,
    String? voice,
    String? language,
    double? speed,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return AudioModel(
      id: id ?? this.id,
      text: text ?? this.text,
      audioUrl: audioUrl ?? this.audioUrl,
      voice: voice ?? this.voice,
      language: language ?? this.language,
      speed: speed ?? this.speed,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Get voice display name from voice ID
  String get voiceDisplayName {
    const voiceNames = {
      'female_1': 'Sarah',
      'male_1': 'James',
      'female_2': 'Emma',
      'male_2': 'Carlos',
      'female_3': 'Yuki',
      'male_3': 'Hans',
    };
    return voiceNames[voice] ?? voice;
  }

  /// Get formatted date
  String get formattedDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  /// Truncated text preview
  String get textPreview {
    if (text.length <= 60) return text;
    return '${text.substring(0, 57)}...';
  }
}
