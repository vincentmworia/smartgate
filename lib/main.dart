import 'package:flutter/material.dart';
import 'package:smartgate/screens/home_screen.dart';

import 'screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const applicationTitle = 'Smart Gate';
  static const applicationPrimaryColor = Color(0xff2F3C7E);
  static const applicationSecondaryColor = Color(0xffFBEAEB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: applicationPrimaryColor,
            secondary: applicationSecondaryColor),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(color: applicationPrimaryColor).copyWith(iconTheme: IconThemeData(color: Colors.white))
      ),
      home: const AuthScreen(),
      routes: {
        AuthScreen.routeName:(context) => const AuthScreen(),
        HomeScreen.routeName:(context) => const HomeScreen()
      },
    );
  }
}
