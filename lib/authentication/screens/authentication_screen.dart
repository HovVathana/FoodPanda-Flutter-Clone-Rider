import 'package:flutter/material.dart';
import 'package:foodpanda_rider/authentication/screens/login_screen.dart';
import 'package:foodpanda_rider/authentication/screens/register_screen.dart';
import 'package:foodpanda_rider/authentication/widgets/custom_textbutton.dart';

class AuthenticationScreen extends StatefulWidget {
  static const String routeName = '/authentication-screen';

  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(Icons.arrow_back),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Center(
                child: Image.asset(
                  'assets/images/foodpanda_logo.png',
                  width: 200,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Earn passive income with us, FoodPanda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            Text(
              'Welcome to FoodPanda!',
              style: TextStyle(
                color: Colors.grey[500]!,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            CustomTextButton(
              text: 'I\'m new here',
              onPressed: () {
                Navigator.pushNamed(context, RegisterScreen.routeName);
              },
              isDisabled: false,
            ),
            CustomTextButton(
              text: 'Sign In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
              isDisabled: false,
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }
}
