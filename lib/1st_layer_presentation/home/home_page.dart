import 'package:flutter/material.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_overlay_wrapper.dart';
import 'package:mark_lxxxv/1st_layer_presentation/home/widgets/home_app_bar.dart';
import 'package:mark_lxxxv/1st_layer_presentation/home/widgets/home_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CoreOverlayWrapper(
      child: Scaffold(
        extendBody: true,
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            const HomeAppBar(),
          ],
        ),
        bottomNavigationBar: HomeNavBar(),
      ),
    );
  }
}
