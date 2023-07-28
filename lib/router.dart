import 'package:flutter/material.dart';
import 'package:foodpanda_rider/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_rider/authentication/screens/login_screen.dart';
import 'package:foodpanda_rider/authentication/screens/register_screen.dart';
import 'package:foodpanda_rider/authentication/screens/send_verification_email_screen.dart';
import 'package:foodpanda_rider/finish_deliver/screens/finish_deliver_screen.dart';
import 'package:foodpanda_rider/home/screens/home_screen.dart';
import 'package:foodpanda_rider/home/screens/home_screen_no_approve.dart';
import 'package:foodpanda_rider/map/screens/map_screen.dart';
import 'package:foodpanda_rider/order_history/screens/order_history_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case HomeScreenNoApprove.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreenNoApprove(),
      );

    case AuthenticationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthenticationScreen(),
      );

    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );

    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterScreen(),
      );

    case SendVerificationEmailScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SendVerificationEmailScreen(),
      );

    case MapScreen.routeName:
      final args = routeSettings.arguments as MapScreen;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MapScreen(
          order: args.order,
        ),
      );

    case FinishDeliverScreen.routeName:
      final args = routeSettings.arguments as FinishDeliverScreen;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => FinishDeliverScreen(
          price: args.price,
        ),
      );

    case OrderHistoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OrderHistoryScreen(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
