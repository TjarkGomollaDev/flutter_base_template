import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';

// ignore: strict_top_level_inference
get allBlocProviders => [
      // theme
      BlocProvider(create: (context) => sl<ThemeBloc>()),
    ];
