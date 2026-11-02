import 'package:bloc/bloc.dart';

mixin XSafeEmitMixin<T> on Cubit<T> {
  void xSafeEmit(T state) {
    if (!isClosed) emit(state);
  }
}
