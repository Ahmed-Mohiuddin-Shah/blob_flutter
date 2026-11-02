import 'package:blob_flutter/configs/routes/route_names.dart';
import 'package:blob_flutter/presentation/editor/editor_host_view.dart';
import 'package:blob_flutter/presentation/widgets/auth_gate.dart';
import 'package:flutter/material.dart';

/// Auth-gated entry into a blank compose session (new sticker).
class UploadGateView extends StatelessWidget {
  const UploadGateView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthGate(
      title: 'upload',
      child: EditorHostView(
        idOrSlug: RouteNames.upload,
        mode: EditorMode.create,
      ),
    );
  }
}
