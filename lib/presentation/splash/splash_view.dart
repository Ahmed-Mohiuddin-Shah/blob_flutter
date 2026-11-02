import 'package:blob_flutter/configs/app/global/app_colors.dart';
import 'package:blob_flutter/configs/routes/pending_deep_link.dart';
import 'package:blob_flutter/logic/splash/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..boot(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (p, c) => c.phase == SplashPhase.ready,
        listener: (context, state) {
          PendingDeepLink.consumeAfterSplash(context);
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.accentGradient,
            ),
            child: BlocBuilder<SplashCubit, SplashState>(
              builder: (context, state) {
                if (state.phase == SplashPhase.forceUpdate) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.message ?? 'Update required',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }
                return const Center(
                  child: Text(
                    'blob',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
