import 'package:blob_flutter/presentation/widgets/glass_app_bar.dart';
import 'package:flutter/material.dart';

/// Full-bleed body under a glass overlay app bar. No SafeArea — callers use
/// [GlassAppBar.heightOf] / MediaQuery.padding for insets.
class BlobScaffold extends StatelessWidget {
  const BlobScaffold({
    super.key,
    required this.title,
    required this.slivers,
    this.actions,
    this.leading,
    this.showSettings = true,
    this.floatingActionButton,
  });

  final String title;
  final List<Widget> slivers;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showSettings;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final barH = GlassAppBar.heightOf(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      // Transparent so scroll content can show through the glass tint.
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButton: floatingActionButton,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomScrollView(
            slivers: [
              // Top inset only — scrolling pulls content under the glass bar.
              SpiverTopInset(barH),
              ...slivers,
              SliverToBoxAdapter(child: SizedBox(height: bottom + 24)),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassAppBar(
              title: title,
              leading: leading,
              actions: actions,
              showSettings: showSettings,
            ),
          ),
        ],
      ),
    );
  }
}

class SpiverTopInset extends StatelessWidget {
  const SpiverTopInset(this.height, {super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: height));
  }
}
