import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Enums
enum MainTab { home, promotions, bookings, offers, account }

// State
class MainTabState {
  final MainTab currentTab;

  const MainTabState({this.currentTab = MainTab.home});

  MainTabState copyWith({MainTab? currentTab}) {
    return MainTabState(currentTab: currentTab ?? this.currentTab);
  }
}

// Cubit
class MainTabCubit extends Cubit<MainTabState> {
  MainTabCubit() : super(const MainTabState());

  void setTab(MainTab tab) {
    emit(state.copyWith(currentTab: tab));
  }
}
