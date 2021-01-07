import 'package:flutter/material.dart';
import 'package:flutter_storage_practices/file%20operations.dart';
import 'package:flutter_storage_practices/sharedPreferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       // body: SharedPreferencesExample(),
        body: FileOperations(),
      ),
    );
  }
}
