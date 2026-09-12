import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronip/models/home_menu_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState(
            activeMenu: HomeSectionEnum.home,
          ),
        );

  void activeMenu(HomeSectionEnum menu) {
    emit(state.copyWith(activeMenu: menu));
  }
}
