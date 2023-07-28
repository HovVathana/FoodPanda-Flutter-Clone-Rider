import 'package:flutter/material.dart';
import 'package:foodpanda_rider/constants/colors.dart';
import 'package:foodpanda_rider/home/controllers/order_controller.dart';
import 'package:foodpanda_rider/home/widgets/my_drawer.dart';
import 'package:foodpanda_rider/home/widgets/order_card.dart';
import 'package:foodpanda_rider/map/screens/map_screen.dart';
import 'package:foodpanda_rider/models/order.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OrderController orderController = OrderController();
  String tabChoice = 'All Order';

  pickOrder({required Order order}) async {
    Order newOrder =
        await orderController.acceptOrder(order: order, context: context);

    Navigator.pushNamed(
      context,
      MapScreen.routeName,
      arguments: MapScreen(order: newOrder),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: scheme.primary,
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 20),
              child: Text(
                'All Orders',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20, bottom: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tabChoice = 'All Order';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: tabChoice == 'All Order'
                            ? scheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          width: 2,
                          color: scheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'All Order',
                        style: TextStyle(
                          color: tabChoice == 'All Order'
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        tabChoice = 'Current Order';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: tabChoice == 'Current Order'
                            ? scheme.primary
                            : Colors.transparent,
                        border: Border.all(
                          width: 2,
                          color: scheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Current Order',
                        style: TextStyle(
                          color: tabChoice == 'Current Order'
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
                stream: tabChoice == 'All Order'
                    ? orderController.fetchOrder()
                    : orderController.fetchProgessOrder(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('loading');
                  }
                  return snapshot.data == null
                      ? const Text('empty')
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final order = snapshot.data![index];

                            return OrderCard(
                              order: order,
                              pickUpOrder: () => pickOrder(order: order),
                            );
                          });
                })
          ],
        ),
      ),
    );
  }
}
