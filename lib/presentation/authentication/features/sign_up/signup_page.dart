import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:tiktok_clone/core/constants/image_constants.dart';
import 'package:tiktok_clone/core/utils/navigator_services.dart';
import 'package:tiktok_clone/presentation/authentication/notifiers/user_notifier.dart';
import 'package:tiktok_clone/route/app_routes.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
                      SignupFormWidget(),
                      SignupFooterWidget(),
                    ])),
          ),
        ));
  }
}

class SignupFormWidget extends StatefulHookConsumerWidget {
  const SignupFormWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupFormWidgetState();
}

class _SignupFormWidgetState extends ConsumerState<SignupFormWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
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
              const Text(
                'Create your account',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: fullnameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2_outlined),
                  labelText: 'Full name',
                  hintText: 'Enter your full name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (input) => input,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_2_outlined),
                  labelText: 'User name',
                  hintText: 'Enter your user name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (input) => input,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
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
                  validator: (input) => input!.length < 6
                      ? "Password shouldn't be less than 6 characters"
                      : null,
                  onChanged: (input) => input),
              const SizedBox(height: 60),
              SizedBox(
                width: size.width,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSignUp,  // Disable button when loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.black87,
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
                    "Sign Up",
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

  Future<void> _handleSignUp() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ref.read(userControllerProvider.notifier).signup(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        fullname: fullnameController.text,
      );

      result.fold(
            (failure) {
          Logger().d('Sign up failed: $failure');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Oh Snap!',
                  message: 'Sign up failed: $failure',
                  contentType: ContentType.failure,
                ),
              ),
            );
        },
            (success) {
          Logger().d('Sign up successful');
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Congratulations',
                  message: 'Sign up successful! Please login to continue.',
                  contentType: ContentType.success,
                ),
              ),
            );
          Navigator.pop(context);
          NavigatorService.pushNamed(AppRoutes.loginPage);
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class SignupFooterWidget extends StatelessWidget {
  const SignupFooterWidget({Key? key}) : super(key: key);

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
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
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
            const Text('Already have an account?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                NavigatorService.pushNamed(AppRoutes.loginPage);
              },
              child: const Text(
                'Log in',
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
