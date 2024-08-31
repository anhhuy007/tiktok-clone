import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/navigator_services.dart';
import 'package:tiktok_clone/presentation/authentication/controller/user_controller.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  static const String routeName = '/log_in';

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoginHeaderWidget(),
                      LoginFormWidget(),
                      LoginFooterWidget(),
                    ])),
          ),
        ));
  }
}

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        alignment: Alignment.center,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image(
          image: AssetImage(ImageConstant.tiktokLogo),
        ),
      ),
      const SizedBox(height: 30),
      Text(
        "Welcome to TikTok!",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
        textAlign: TextAlign.center,
      ),
      Text(
        // random quote
        "It's a place where you can find the best short videos",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
        textAlign: TextAlign.start,
      ),
    ]);
  }
}

class LoginFormWidget extends StatefulHookConsumerWidget {
  const LoginFormWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends ConsumerState<LoginFormWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isLoading = false;

  void togglePasswordView() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_2_outlined),
              labelText: 'Email',
              hintText: 'Enter your email',
              border: OutlineInputBorder(),
            ),
            onChanged: (input) => input,
          ),
          const SizedBox(height: 10),
          TextFormField(
              controller: passwordController,
              obscureText: isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint_rounded),
                suffixIcon: IconButton(
                    onPressed: togglePasswordView,
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    )
                ),
                labelText: 'Password',
                hintText: 'Enter your password',
                border: const OutlineInputBorder(),
              ),
              validator: (input) => input!.length < 3
                  ? "Password should be more than 3 characters"
                  : null,
              onChanged: (input) => input),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: TextButton(
                  onPressed: () {
                    // ForgotPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 5),
        SizedBox(
            width: size.width,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,  // Disable button when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                "Log In",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ref.read(userControllerProvider.notifier).login(
        email: emailController.text,
        password: passwordController.text,
      );

      result.fold(
            (failure) {
          Logger().d('Login failed: $failure');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Oh Snap!',
                  message: 'Login failed: $failure',
                  contentType: ContentType.failure,
                ),
              ),
            );
        },
            (success) {
          Logger().d('Login successful');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Congratulations',
                  message: 'Login successful!',
                  contentType: ContentType.success,
                ),
              ),
            );
          Navigator.pop(context);
          NavigatorService.pushNamed(AppRoutes.homeScreen);
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        alignment: Alignment.center,
        width: size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 10),
          const Text(
            'OR',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: size.width,
            child: OutlinedButton.icon(
              icon:
                  Image(image: AssetImage(ImageConstant.googleIcon), width: 20),
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: Colors.black, width: 1),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Don\'t have an account?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                NavigatorService.pushNamed(AppRoutes.signUpScreen);
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ])
        ]));
  }
}
