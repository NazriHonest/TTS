import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mock_tts_flutter/core/services/api_service.dart';
import 'package:mock_tts_flutter/features/tts/data/models/audio_model.dart';
import 'package:mock_tts_flutter/core/constants/app_constants.dart';

// ── API Service Provider ──
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// ── Audio List State ──
final audioListProvider =
    StateNotifierProvider<AudioListNotifier, AsyncValue<List<AudioModel>>>(
  (ref) => AudioListNotifier(ref.read(apiServiceProvider)),
);

class AudioListNotifier extends StateNotifier<AsyncValue<List<AudioModel>>> {
  final ApiService _apiService;

  AudioListNotifier(this._apiService) : super(const AsyncValue.loading()) {
    loadAudioList();
  }

  Future<void> loadAudioList() async {
    state = const AsyncValue.loading();
    try {
      final list = await _apiService.getAudioList();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addAudio(AudioModel audio) {
    state.whenData((list) {
      state = AsyncValue.data([audio, ...list]);
    });
  }

  void toggleFavorite(String audioId) {
    state.whenData((list) {
      state = AsyncValue.data(
        list.map((a) {
          if (a.id == audioId) {
            return a.copyWith(isFavorite: !a.isFavorite);
          }
          return a;
        }).toList(),
      );
    });
    _apiService.toggleFavorite(audioId);
  }

  AudioModel? getAudioById(String id) {
    return state.whenOrNull(
      data: (list) {
        try {
          return list.firstWhere((a) => a.id == id);
        } catch (_) {
          return null;
        }
      },
    );
  }
}

// ── Favorites (derived) ──
final favoritesProvider = Provider<List<AudioModel>>((ref) {
  final audioList = ref.watch(audioListProvider);
  return audioList.whenOrNull(
        data: (list) => list.where((a) => a.isFavorite).toList(),
      ) ??
      [];
});

// ── TTS Generation State ──
enum TTSGenerationStatus { idle, generating, success, error }

class TTSGenerationState {
  final TTSGenerationStatus status;
  final AudioModel? result;
  final String? errorMessage;

  const TTSGenerationState({
    this.status = TTSGenerationStatus.idle,
    this.result,
    this.errorMessage,
  });

  TTSGenerationState copyWith({
    TTSGenerationStatus? status,
    AudioModel? result,
    String? errorMessage,
  }) {
    return TTSGenerationState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final ttsGenerationProvider =
    StateNotifierProvider<TTSGenerationNotifier, TTSGenerationState>(
  (ref) => TTSGenerationNotifier(ref),
);

class TTSGenerationNotifier extends StateNotifier<TTSGenerationState> {
  final Ref _ref;

  TTSGenerationNotifier(this._ref) : super(const TTSGenerationState());

  Future<void> generateSpeech({
    required String text,
    required String voice,
    required String language,
    required double speed,
  }) async {
    state = state.copyWith(status: TTSGenerationStatus.generating);

    try {
      final apiService = _ref.read(apiServiceProvider);
      final result = await apiService.generateTTS(
        text: text,
        voice: voice,
        language: language,
        speed: speed,
      );

      _ref.read(audioListProvider.notifier).addAudio(result);

      state = TTSGenerationState(
        status: TTSGenerationStatus.success,
        result: result,
      );
    } catch (e) {
      state = TTSGenerationState(
        status: TTSGenerationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    state = const TTSGenerationState();
  }
}

// ── Settings Providers ──
final isDarkModeProvider = StateProvider<bool>((ref) => true);

final defaultVoiceProvider = StateProvider<String>(
  (ref) => AppConstants.voices.first.id,
);

final defaultLanguageProvider = StateProvider<String>(
  (ref) => AppConstants.languages.first.code,
);

// ── Selected voice/language for generation ──
final selectedVoiceProvider = StateProvider<String>(
  (ref) => ref.read(defaultVoiceProvider),
);

final selectedLanguageProvider = StateProvider<String>(
  (ref) => ref.read(defaultLanguageProvider),
);

final selectedSpeedProvider = StateProvider<double>((ref) => 1.0);

// ── Auth (mock) ──
final isLoggedInProvider = StateProvider<bool>((ref) => false);

// ── Bottom Nav Index ──
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
