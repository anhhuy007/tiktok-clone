import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tiktok_clone/core/utils/size_utils.dart' as size_utils;
import 'package:tiktok_clone/presentation/profile/profile_page/profile_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/profile_page_container.dart';
import 'core/utils/size_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Sizer(builder: (BuildContext context, Orientation orientation, size_utils.DeviceType deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: ResponsiveSizer(
              builder: (context, orientation, screenSize) => const MyHomePage(title: "Test")),
        );
      },
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return ProfilePageContainer();
  }
}
