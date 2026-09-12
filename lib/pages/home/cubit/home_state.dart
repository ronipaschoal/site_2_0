part of 'home_cubit.dart';

class HomeState {
  final HomeSectionEnum activeMenu;

  HomeState({
    required this.activeMenu,
  });

  HomeState copyWith({
    HomeSectionEnum? activeMenu,
  }) {
    return HomeState(
      activeMenu: activeMenu ?? this.activeMenu,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeState && other.activeMenu == activeMenu;

  @override
  int get hashCode => activeMenu.hashCode;
}
