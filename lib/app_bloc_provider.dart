import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/ai_chat/ai_chat_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/chat_bloc/chat_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/chat_list_bloc/chat_list_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/search_bloc/search_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/onboarding/onboarding_bloc/onboarding_bloc.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';

// ignore: strict_top_level_inference
get allBlocProviders => [
      // onboarding
      BlocProvider(create: (context) => sl<OnboardingBloc>()),
      // auth
      BlocProvider(create: (context) => sl<SignInBloc>()),
      BlocProvider(create: (context) => sl<SignUpBloc>()),
      BlocProvider(create: (context) => sl<ResetPasswordBloc>()),
      BlocProvider(create: (context) => sl<AuthBloc>()),
      // theme
      BlocProvider(create: (context) => sl<ThemeBloc>()),
      // application
      BlocProvider(create: (context) => sl<ApplicationBloc>()),
      BlocProvider(create: (context) => sl<HomeBloc>()),
      BlocProvider(create: (context) => sl<AiChatBloc>()),
      BlocProvider(create: (context) => sl<SearchBloc>()),
      BlocProvider(create: (context) => sl<ChatBloc>()),
      BlocProvider(create: (context) => sl<ChatListBloc>()),
    ];
