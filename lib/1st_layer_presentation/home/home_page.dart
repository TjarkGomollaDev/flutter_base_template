import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/widgets/home_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const HomeAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Center(
                child: Text('Placeholder Home Page'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
