import 'package:flutter/material.dart';
import 'package:foodpanda_rider/authentication/screens/authentication_screen.dart';
import 'package:foodpanda_rider/constants/colors.dart';
import 'package:foodpanda_rider/order_history/screens/order_history_screen.dart';
import 'package:foodpanda_rider/providers/authentication_provider.dart';
import 'package:foodpanda_rider/widgets/my_alert_dialog.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = context.watch<AuthenticationProvider>();

    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Builder(builder: (c) {
            return DrawerHeader(
              decoration: BoxDecoration(
                color: scheme.primary,
                border: Border.all(color: scheme.primary),
              ),
              child: ap.isSignedIn
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              ap.name!.isNotEmpty
                                  ? ap.name!.substring(0, 1)
                                  : 'F',
                              style: TextStyle(
                                color: scheme.primary,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          ap.name!.isNotEmpty ? ap.name! : 'Foodpanda',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        Scaffold.of(c).closeDrawer();
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign up/Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )),
            );
          }),
          Column(
            children: [
              listTile(
                context,
                'Delivery History',
                Icons.delivery_dining_outlined,
                () {
                  Navigator.pushNamed(context, OrderHistoryScreen.routeName);
                },
              ),
              listTile(
                context,
                'Earnings',
                Icons.attach_money_rounded,
                () {},
              ),
              listTile(
                context,
                'Rating',
                Icons.star_border_purple500_outlined,
                () {},
              ),
              listTile(
                context,
                'Account',
                Icons.person_4_outlined,
                () {},
              ),
            ],
          ),
          Container(
            height: 1,
            color: MyColors.borderColor,
          ),
          listTile(
            context,
            'Settings',
            null,
            () {
              Navigator.pop(context);
            },
          ),
          listTile(
            context,
            'Terms & Conditions / Privacy',
            null,
            () {
              Navigator.pop(context);
            },
          ),
          ap.isSignedIn
              ? Builder(builder: (c) {
                  return listTile(
                    context,
                    'Log out',
                    null,
                    () {
                      Scaffold.of(c).closeDrawer();
                      showDialog(
                        context: c,
                        builder: (ctx) => MyAlertDialog(
                          title: 'Logging out?',
                          subtitle:
                              'Thanks for stopping by. See you again soon!',
                          action1Name: 'Cancel',
                          action2Name: 'Log out',
                          action1Func: () {
                            Navigator.pop(ctx);
                          },
                          action2Func: () {
                            ap.userSignOut();
                            Navigator.pop(ctx);
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AuthenticationScreen.routeName,
                              (route) => false,
                            );
                          },
                        ),
                      );
                    },
                  );
                })
              : const SizedBox(),
        ],
      ),
    );
  }

  ListTile listTile(
      BuildContext context, String text, IconData? icon, VoidCallback onTap) {
    return icon == null
        ? ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            onTap: onTap,
          )
        : ListTile(
            title: Text(
              text,
              style: const TextStyle(
                color: MyColors.textColor,
                fontSize: 14,
              ),
            ),
            leading: Icon(
              icon,
              color: scheme.primary,
            ),
            onTap: onTap,
          );
  }
}
