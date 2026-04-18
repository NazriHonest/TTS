import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mock_tts_flutter/core/constants/app_constants.dart';
import 'package:mock_tts_flutter/features/tts/data/models/audio_model.dart';

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({String? baseUrl, http.Client? client})
      : baseUrl = baseUrl ?? AppConstants.apiBaseUrl,
        _client = client ?? http.Client();

  /// Generate TTS audio from text
  Future<AudioModel> generateTTS({
    required String text,
    required String voice,
    required String language,
    required double speed,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/tts/generate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'text': text,
              'voice': voice,
              'language': language,
              'speed': speed,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return AudioModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to generate TTS: ${response.statusCode}');
    } catch (e) {
      // Fallback to local mock if server is unreachable
      return _generateLocalMock(text, voice, language, speed);
    }
  }

  /// Get list of generated audio items
  Future<List<AudioModel>> getAudioList() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/audio'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AudioModel.fromJson(json)).toList();
      }
      throw Exception('Failed to get audio list: ${response.statusCode}');
    } catch (e) {
      return _getLocalMockList();
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String audioId) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/audio/favorite'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'audio_id': audioId}),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_favorite'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ── Local Fallback Mocks ──

  Future<AudioModel> _generateLocalMock(
    String text,
    String voice,
    String language,
    double speed,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    return AudioModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      audioUrl: AppConstants.sampleAudioUrl,
      voice: voice,
      language: language,
      speed: speed,
      createdAt: DateTime.now(),
      isFavorite: false,
    );
  }

  List<AudioModel> _getLocalMockList() {
    return [
      AudioModel(
        id: 'local-001',
        text: 'Ku soo dhawaaw Nova Voice, barnaamijkaaga gaarka ah ee qoraalka u beddela hadal.',
        audioUrl: AppConstants.sampleAudioUrl,
        voice: 'female_1',
        language: 'so-SO',
        speed: 1.0,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isFavorite: true,
      ),
      AudioModel(
        id: 'local-002',
        text: 'Waqtigu waa qaali, ee ka faa\'iidayso adigoo qabanaya hawlo ku anfacaya.',
        audioUrl: AppConstants.sampleAudioUrl,
        voice: 'male_1',
        language: 'so-SO',
        speed: 1.0,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isFavorite: false,
      ),
      AudioModel(
        id: 'local-003',
        text: 'Sirdoonka macmalka ah wuxuu isbedel weyn ku samaynayaa habka aan u wada xiriirno.',
        audioUrl: AppConstants.sampleAudioUrl,
        voice: 'female_2',
        language: 'so-SO',
        speed: 0.8,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isFavorite: false,
      ),
      AudioModel(
        id: 'local-004',
        text: 'Subax wanaagsan, kani waa tijaabo lagu eegayo in qoraalka loo rogo cod.',
        audioUrl: AppConstants.sampleAudioUrl,
        voice: 'male_2',
        language: 'so-SO',
        speed: 1.2,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isFavorite: true,
      ),
      AudioModel(
        id: 'local-005',
        text: 'Barashada luqado cusub waxay kuu furaysaa albaabada aduunka iyo dhaqamadiisa.',
        audioUrl: AppConstants.sampleAudioUrl,
        voice: 'female_1',
        language: 'so-SO',
        speed: 1.0,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isFavorite: false,
      ),
    ];
  }
}
