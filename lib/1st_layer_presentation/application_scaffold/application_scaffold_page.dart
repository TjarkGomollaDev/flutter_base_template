import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/home_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_2/page_2.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_3/page_3.dart';
import 'package:flutter_base_template/1st_layer_presentation/page_4/page_4.dart';
import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      buildWhen: (previous, current) => previous.index != current.index,
      builder: (context, state) {
        // scaffold of the application
        return Scaffold(
          body: IndexedStack(
            index: state.index,
            // sub pages of the application
            children: const [
              HomePage(),
              Page2(),
              Page3(),
              Page4(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.index,
            onTap: (index) {
              context.read<ApplicationBloc>().add(ApplicationEventChangePageIndex(index: index));
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Page 2'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Page 3'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Page 4'),
            ],
          ),
        );
      },
    );
  }
}
