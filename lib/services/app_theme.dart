import 'package:flutter/material.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
}

class AppThemes {
  static final appThemeData = {
    AppTheme.darkTheme: ThemeData(
      primarySwatch: Colors.teal,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      dividerColor: Colors.black54,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.tealAccent),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(
          Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(color: Colors.white)),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent),
        ),
        labelStyle: TextStyle(
          color: Colors.tealAccent,
        ),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black45,
        unselectedItemColor: Colors.white,
      ),
    ),

    //
    //

    AppTheme.lightTheme: ThemeData(
      primarySwatch: Colors.cyan,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      dividerColor: const Color(0xff757575),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.cyan),
        ),
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(color: Colors.black),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black54,
        unselectedItemColor: Colors.white,
      ),
    ),
  };
}
