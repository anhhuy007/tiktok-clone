import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/core/utils/navigator_services.dart';
import 'package:tiktok_clone/presentation/authentication/features/login/login_page.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/auth_notifier.dart';
import 'package:tiktok_clone/presentation/home/home_page_container.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import 'package:tiktok_clone/theme/theme_helper.dart';
import 'core/utils/size_utils.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authProvider.notifier).loadAuthState();
    final authState = ref.watch(authProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final shouldPop = await _onWillPop(context);
        if (shouldPop) {
          navigator.pop();
        }
      },
      child: Sizer(
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
                  titleSmall: CustomTextStyles.titleSmall
              ),
              useMaterial3: true,
            ),
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            routes: AppRoutes.routes,
            home: authState.isAuthenticated
                ? const HomePageContainer()
                : const LogInPage(),
          );
        },
      ),
    );
  }
}