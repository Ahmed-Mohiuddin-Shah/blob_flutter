import 'package:blob_flutter/configs/app/global/app_globals.dart';
import 'package:blob_flutter/logic/auth/auth_cubit.dart';
import 'package:blob_flutter/presentation/widgets/blob_scaffold.dart';
import 'package:blob_flutter/presentation/widgets/busy_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wraps member-only screens; prompts sign-in when needed.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child, this.title = 'sign in'});

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.signedIn) return child;
        return BlobScaffold(
          title: title,
          showSettings: false,
          slivers: [
            SliverFillRemaining(
              child: Center(
                child: BusyButton(
                  label: 'Sign in to continue',
                  busy: state.busy,
                  onPressed: () async {
                    final ok = await context.read<AuthCubit>().signIn();
                    if (ok) await AppGlobals.meCubit.load();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
