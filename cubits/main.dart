import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../utils/index.dart';
import 'index.dart';

enum ThemeState { system, light, dark }

final Map<ThemeState, ThemeData> _themeData = {
  ThemeState.light: Style.light,
  ThemeState.dark: Style.dark
};

class MainCubit extends HydratedCubit<MainState> {
  MainCubit() : super(const MainState());

  @override
  MainState fromJson(Map<String, dynamic> json) {
    return MainState(
      themeState: ThemeState.values[json['themeState'] as int],
      status: Status.values[json['status'] as int],
    );
  }

  @override
  Map<String, dynamic> toJson(MainState state) {
    return {
      'themeState': state.themeState.index,
      'status': state.status.index,
    };
  }

  ThemeState get theme => state.themeState;

  void setTheme(ThemeState themeState) =>
      emit(state.copyWith(themeState: themeState));

  Status get status => state.status;

  void setStatus(Status status) => emit(state.copyWith(status: status));

  ThemeData? get light => _themeData[ThemeState.light];

  ThemeData? get dark => _themeData[ThemeState.dark];

  ThemeMode get themeMode {
    switch (state.themeState) {
      case ThemeState.light:
        return ThemeMode.light;
      case ThemeState.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

class MainState extends Equatable {
  final ThemeState themeState;
  final Status status;

  const MainState({
    this.themeState = ThemeState.system,
    this.status = Status.initial,
  });

  MainState copyWith({ThemeState? themeState, Status? status}) {
    return MainState(
      themeState: themeState ?? this.themeState,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [themeState, status];
}
