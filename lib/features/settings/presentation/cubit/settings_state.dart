import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isSoundEnabled;
  final bool isHapticEnabled;
  final bool isTimerVisible;
  final String language; // 'am' or 'en'
  final bool isFirstRun;
  final String playerName;

  const SettingsState({
    this.isSoundEnabled = true,
    this.isHapticEnabled = true,
    this.isTimerVisible = false,
    this.language = 'am',
    this.isFirstRun = true,
    this.playerName = '',
  });

  SettingsState copyWith({
    bool? isSoundEnabled,
    bool? isHapticEnabled,
    bool? isTimerVisible,
    String? language,
    bool? isFirstRun,
    String? playerName,
  }) {
    return SettingsState(
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isHapticEnabled: isHapticEnabled ?? this.isHapticEnabled,
      isTimerVisible: isTimerVisible ?? this.isTimerVisible,
      language: language ?? this.language,
      isFirstRun: isFirstRun ?? this.isFirstRun,
      playerName: playerName ?? this.playerName,
    );
  }

  @override
  List<Object?> get props => [
        isSoundEnabled,
        isHapticEnabled,
        isTimerVisible,
        language,
        isFirstRun,
        playerName,
      ];
}
