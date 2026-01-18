import 'package:flutter/material.dart';
import 'package:tribe_up/config/di/di.dart';
import 'package:tribe_up/flower_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}
