import 'package:chat_app/utils/app_constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.ROUTE_SPLASHPAGE,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
        ),
        useMaterial3: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
    ),
  );
}
