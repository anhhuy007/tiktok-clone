import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/presentation/home/home_page/home_page.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import 'package:tiktok_clone/theme/theme_helper.dart';

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
        return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorSchemes.primaryColorScheme,
              textTheme: TextTheme(
                  headlineSmall: CustomTextStyles.headlineSmall,
                  labelMedium: CustomTextStyles.labelMedium,
                  titleLarge: CustomTextStyles.titleLarge,
                  titleMedium: CustomTextStyles.titleMedium,
                  titleSmall: CustomTextStyles.titleSmall
              ),
              useMaterial3: true,
            ),
          title: 'Flutter Demo',
          home: HomeScreen(),
          routes: AppRoutes.routes,
        );
      },
      )
    );
  }
}
