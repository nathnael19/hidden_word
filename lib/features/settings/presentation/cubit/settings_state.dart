import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isSoundEnabled;
  final bool isHapticEnabled;
  final bool isTimerVisible;
  final String language; // 'am' or 'en'

  const SettingsState({
    this.isSoundEnabled = true,
    this.isHapticEnabled = true,
    this.isTimerVisible = false,
    this.language = 'am',
  });

  SettingsState copyWith({
    bool? isSoundEnabled,
    bool? isHapticEnabled,
    bool? isTimerVisible,
    String? language,
  }) {
    return SettingsState(
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isHapticEnabled: isHapticEnabled ?? this.isHapticEnabled,
      isTimerVisible: isTimerVisible ?? this.isTimerVisible,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
        isSoundEnabled,
        isHapticEnabled,
        isTimerVisible,
        language,
      ];
}
