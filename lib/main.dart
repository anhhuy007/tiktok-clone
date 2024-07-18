import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart';
import 'package:tiktok_clone/presentation/home/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'TikTok Clone',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const HomeScreen()
          );
        }
      )
    );
  }
}

