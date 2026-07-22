import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/bloc/auth/auth_cubit.dart';
import 'package:tribe_up/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final authCubit = getIt<AuthCubit>();
  await authCubit.checkAuthStatus();

  runApp(BlocProvider.value(value: authCubit, child: const TribeUpApp()));
}
