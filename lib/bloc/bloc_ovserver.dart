
import 'package:flutter_bloc/flutter_bloc.dart';

//Custom Bloc ovserver to observe all the blocs
class CustomBlocOvserver extends BlocObserver{
  @override
  void onEvent(Bloc bloc, Object? event) {
    print('Bloc Event==> ${bloc.runtimeType}, $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print('Bloc change==> ${bloc.runtimeType}, $change');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Bloc transition==> ${bloc.runtimeType}, $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('Bloc Error==> ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }
}