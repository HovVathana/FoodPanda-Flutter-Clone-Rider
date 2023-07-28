import 'package:flutter/material.dart';
import 'package:foodpanda_rider/authentication/widgets/custom_textbutton.dart';

class FinishDeliverScreen extends StatelessWidget {
  final double price;
  static const String routeName = '/finish-deliver-screen';

  const FinishDeliverScreen({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Image.asset(
                'assets/images/rider.webp',
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Congratulations, you just earn \$ $price',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Stay safe on your next ride',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomTextButton(
                text: 'New Ride',
                onPressed: () {
                  Navigator.pop(context);
                },
                isDisabled: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
