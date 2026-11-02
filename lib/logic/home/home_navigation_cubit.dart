import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeTab { stickers, blobbers, prints, collections, search }

class HomeNavigationCubit extends Cubit<int> {
  HomeNavigationCubit() : super(0);

  void selectTab(int index) {
    if (index < 0 || index >= HomeTab.values.length) return;
    emit(index);
  }

  void select(HomeTab tab) => selectTab(tab.index);
}
