import 'package:flutter/material.dart';
import 'package:foodpanda_rider/authentication/screens/send_verification_email_screen.dart';
import 'package:foodpanda_rider/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_rider/constants/colors.dart';
import 'package:foodpanda_rider/home/screens/home_screen.dart';
import 'package:foodpanda_rider/providers/authentication_provider.dart';
import 'package:foodpanda_rider/providers/internet_provider.dart';
import 'package:foodpanda_rider/widgets/custom_textfield.dart';
import 'package:foodpanda_rider/widgets/my_snack_bar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isFocus = false;
  bool isObscure = false;
  String emailText = '';
  String passwordText = '';
  String errorText = '';
  String errorEmailText = '';

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : '';
  }

  String? validPassword(String? value) {
    return value!.length < 6
        ? 'Password has to be at least 6 characters long'
        : '';
  }

  handleLogin() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final internetProvider = context.read<InternetProvider>();

    setState(() {
      errorEmailText = validateEmail(emailController.text.trim().toString())!;
      errorText = validPassword(passwordController.text.toString())!;
    });

    if (errorText.isEmpty && errorEmailText.isEmpty) {
      await internetProvider.checkInternetConnection();
      if (internetProvider.hasInternet == false) {
        Navigator.pop(context);
        openSnackbar(context, 'Check your internet connection', scheme.primary);
      } else {
        await authenticationProvider
            .signInWithEmailAndPassword(
          emailController.text.trim().toString(),
          passwordController.text.toString(),
        )
            .then((value) async {
          if (authenticationProvider.hasError) {
            openSnackbar(
              context,
              authenticationProvider.errorCode,
              scheme.primary,
            );
            authenticationProvider.resetError();
          } else {
            await authenticationProvider
                .getUserDataFromFirestore(authenticationProvider.uid);
            await authenticationProvider.saveDataToSharedPreferences();
            await authenticationProvider.setSignIn();
            if (authenticationProvider.emailVerified) {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
              Navigator.pushNamed(
                  context, SendVerificationEmailScreen.routeName);
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        actions: [
          TextButton(
            onPressed: passwordText.isEmpty ? null : handleLogin,
            child: Text(
              'Continue',
              style: TextStyle(
                color: passwordText.isEmpty || emailText.isEmpty
                    ? Colors.grey[400]
                    : scheme.primary,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 20),
                    child: Image.asset(
                      'assets/images/login_icon.png',
                      width: 60,
                    ),
                  ),
                  const Text(
                    'Log in with your email',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    controller: emailController,
                    labelText: 'Email',
                    onChanged: (value) {
                      setState(() {
                        emailText = value;
                      });
                    },
                    errorText: errorEmailText,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    noIcon: false,
                    onChanged: (value) {
                      setState(() {
                        passwordText = value;
                      });
                    },
                    errorText: errorText,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'I forgot my password',
                      style: TextStyle(
                        color: scheme.primary,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            CustomTextButton(
              text: 'Continue',
              onPressed: handleLogin,
              isDisabled: passwordText.isEmpty || emailText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
