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

  Future<bool?> _onWillPop(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to exit the app?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authProvider.notifier).loadAuthState();
    final authState = ref.watch(authProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        final bool shouldPop = await _onWillPop(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
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
            onGenerateRoute: AppRoutes.generateRoute,
            home: authState.isAuthenticated
                ? const HomePageContainer()
                : const LogInPage(),
          );
        },
      ),
    );
  }
}