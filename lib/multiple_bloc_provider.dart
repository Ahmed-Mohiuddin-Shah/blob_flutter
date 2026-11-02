import 'package:blob_flutter/configs/app/global/app_globals.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultipleBlocProviders extends StatelessWidget {
  const MultipleBlocProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AppGlobals.homeNavigationCubit),
        BlocProvider(create: (_) => AppGlobals.appSettingsCubit),
        BlocProvider(create: (_) => AppGlobals.themeCubit),
        BlocProvider(create: (_) => AppGlobals.appVersionCubit),
        BlocProvider(create: (_) => AppGlobals.authCubit),
        BlocProvider(create: (_) => AppGlobals.meCubit),
      ],
      child: child,
    );
  }
}
