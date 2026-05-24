import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/ai_chat/ai_chat_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/chat/chat_list/chat_list_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/error_screen/error_page.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/home_page.dart';
import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/search_bloc/search_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:flutter_base_template/main.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.flag != current.flag,
      listener: (context, state) {
        // Sign Out the user and go to Sign In page
        if (state.flag == AuthFlag.unauthenticated) {
          context.read<ApplicationBloc>().add(ApplicationEventResetPageIndex());
          //Navigator.pushNamedAndRemoveUntil(context, RouteNames.SIGN_IN, (route) => false);
          context.read<SearchBloc>().add(SearchEventResetRecentSearches());
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MyApp(),
          ));
        }
      },
      builder: (context, state) {
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
                  AiChatPage(),
                  ChatListPage(),
                  ErrorPage(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
