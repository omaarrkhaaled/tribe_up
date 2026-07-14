import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/core/bloc/auth/auth_cubit.dart';
import 'package:tribe_up/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
      child: const TribeUpApp(),
    ),
  );
}
