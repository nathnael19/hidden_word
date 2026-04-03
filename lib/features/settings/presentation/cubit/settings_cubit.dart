import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleSound() {
    emit(state.copyWith(isSoundEnabled: !state.isSoundEnabled));
  }

  void toggleHaptic() {
    emit(state.copyWith(isHapticEnabled: !state.isHapticEnabled));
  }

  void toggleTimer() {
    emit(state.copyWith(isTimerVisible: !state.isTimerVisible));
  }

  void setLanguage(String langCode) {
    emit(state.copyWith(language: langCode));
  }
}
