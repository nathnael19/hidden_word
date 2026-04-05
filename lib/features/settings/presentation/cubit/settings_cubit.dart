import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  static const _keySound = 'settings_sound';
  static const _keyHaptic = 'settings_haptic';
  static const _keyTimer = 'settings_timer';
  static const _keyLanguage = 'settings_language';

  SettingsCubit({required this.sharedPreferences})
      : super(SettingsState(
          isSoundEnabled: sharedPreferences.getBool(_keySound) ?? true,
          isHapticEnabled: sharedPreferences.getBool(_keyHaptic) ?? true,
          isTimerVisible: sharedPreferences.getBool(_keyTimer) ?? false,
          language: sharedPreferences.getString(_keyLanguage) ?? 'en',
        ));

  void toggleSound() {
    final newValue = !state.isSoundEnabled;
    sharedPreferences.setBool(_keySound, newValue);
    emit(state.copyWith(isSoundEnabled: newValue));
  }

  void toggleHaptic() {
    final newValue = !state.isHapticEnabled;
    sharedPreferences.setBool(_keyHaptic, newValue);
    emit(state.copyWith(isHapticEnabled: newValue));
  }

  void toggleTimer() {
    final newValue = !state.isTimerVisible;
    sharedPreferences.setBool(_keyTimer, newValue);
    emit(state.copyWith(isTimerVisible: newValue));
  }

  void setLanguage(String langCode) {
    sharedPreferences.setString(_keyLanguage, langCode);
    emit(state.copyWith(language: langCode));
  }
}
