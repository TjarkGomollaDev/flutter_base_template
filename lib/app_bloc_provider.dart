import 'package:flutter_base_template/2nd_layer_application/application/locale_bloc/locale_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/theme_bloc/theme_bloc.dart';
import 'package:flutter_base_template/app_dependency_injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider<StateStreamableSource<Object?>>> get allBlocProviders => [
  BlocProvider<ThemeBloc>(create: (_) => sl<ThemeBloc>()),
  BlocProvider<LocaleBloc>(create: (_) => sl<LocaleBloc>()),
];
