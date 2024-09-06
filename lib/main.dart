import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tiktok_clone/core/utils/navigator_services.dart';
import 'package:tiktok_clone/presentation/authentication/features/login/login_page.dart';
import 'package:tiktok_clone/presentation/authentication/repo/auth_repo.dart';
import 'package:tiktok_clone/presentation/home/home_page/home_page.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import 'package:tiktok_clone/theme/theme_helper.dart';
import 'core/utils/size_utils.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
            navigatorKey: NavigatorService.navigatorKey,
            theme: ThemeData(
              colorScheme: ColorSchemes.primaryColorScheme,
              textTheme: TextTheme(
                  headlineSmall: CustomTextStyles.headlineSmall,
                  labelMedium: CustomTextStyles.labelMedium,
                  titleLarge: CustomTextStyles.titleLarge,
                  titleMedium: CustomTextStyles.titleMedium,
                  titleSmall: CustomTextStyles.titleSmall),
              useMaterial3: true,
            ),
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            routes: AppRoutes.routes,
            home: ref
                .watch(getIsAuthenticatedProvider)
                .when(
                  data: (bool isAuthenticated) => isAuthenticated
                      ? const HomeScreen()
                      : const LogInPage(),
                  loading: () => const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stackTrace) => const Scaffold(
                    body: Center(
                      child: Text('Error'),
                    ),
                  ),
            )
        );
      },
    );
  }
}
