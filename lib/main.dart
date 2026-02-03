import "package:vibe_connect/utils/app_constants/app_constants.dart";
import "package:vibe_connect/utils/simple_bloc_observer.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/date_symbol_data_local.dart";

import "firebase_options.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting(); // Initialize for intl package
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.ROUTE_SPLASHPAGE,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        useMaterial3: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
    ),
  );
}
