import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Hive pour le stockage local
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.authBox);
  await Hive.openBox(AppConstants.settingsBox);
  
  // Nouvelles boîtes pour les modules employés et paramètres
  await Hive.openBox('employee_box');
  await Hive.openBox('settings_box');
  await Hive.openBox('store_settings_box');
  
  runApp(
    const ProviderScope(
      child: EdenComptaApp(),
    ),
  );
}
