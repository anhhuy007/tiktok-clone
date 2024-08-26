import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/home/home_page/home_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page/profile_page.dart';
import 'package:tiktok_clone/presentation/profile/profile_page_container/profile_page_container.dart';

import 'core/utils/size_utils.dart';
import 'core/utils/size_utils.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Sizer(builder: (context, orientation, deviceType) {
        return const MaterialApp(
          title: 'Flutter Demo',
          home: HomeScreen()
        );
      },
      )
    );
  }
}
