import 'package:chat_app/utils/AppConstants/appconstants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.ROUTE_SPLASHPAGE,
      routes: AppRoutes.getRoutes(),
    ),
  );
}
