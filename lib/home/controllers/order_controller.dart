import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_rider/constants/helper.dart';
import 'package:foodpanda_rider/models/order.dart' as model;
import 'package:foodpanda_rider/models/rider.dart';
import 'package:foodpanda_rider/models/user.dart' as userModel;
import 'package:foodpanda_rider/providers/authentication_provider.dart';
import 'package:foodpanda_rider/providers/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrderController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<model.Order>> fetchOrder() {
    return firestore.collection('orders').snapshots().map(
      (event) {
        List<model.Order> ordersList = [];
        for (var document in event.docs) {
          model.Order tempOrder = model.Order.fromMap(document.data());

          if (!tempOrder.isRiderAccept) {
            ordersList.add(tempOrder);
          }
        }
        return ordersList;
      },
    );
  }

  Future<List<model.Order>> fetchOrderHistory() async {
    List<model.Order> ordersList = [];
    var orderSnapshot = await firestore
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .orderBy('time', descending: true)
        .get();
    for (var tempData in orderSnapshot.docs) {
      model.Order tempOrder = model.Order.fromMap(tempData.data());
      if (tempOrder.isDelivered) {
        ordersList.add(tempOrder);
      }
    }

    return ordersList;
  }

  Stream<List<model.Order>> fetchProgessOrder() {
    return firestore
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .snapshots()
        .map(
      (event) {
        List<model.Order> ordersList = [];
        for (var document in event.docs) {
          model.Order tempOrder = model.Order.fromMap(document.data());

          if (tempOrder.isRiderAccept && !tempOrder.isDelivered) {
            ordersList.add(tempOrder);
          }
        }
        return ordersList;
      },
    );
  }

  Future<model.Order> acceptOrder({
    required model.Order order,
    required BuildContext context,
  }) async {
    final DocumentReference ref;
    ref = firestore.collection('orders').doc(order.id);
    await ref.delete().catchError((error) => print(error.toString()));

    final ap = context.read<AuthenticationProvider>();
    final lp = context.read<LocationProvider>();

    await lp.getCurrentLocation();
    await ap.getUserDataFromFirestore(FirebaseAuth.instance.currentUser!.uid);

    order.isRiderAccept = true;
    order.isShopAccept = true;
    order.rider = Rider(
      user: userModel.User(uid: ap.uid!, email: ap.email!, name: ap.name!),
      latitude: lp.latitude!,
      longitude: lp.longitude!,
    );
    await firestore
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(order.id)
        .set(order.toMap());

    await firestore
        .collection('sellers')
        .doc(order.shop.uid)
        .collection('orders')
        .doc(order.id)
        .set(order.toMap());

    await firestore
        .collection('users')
        .doc(order.user.uid)
        .collection('orders')
        .doc(order.id)
        .set(order.toMap());

    return order;
  }

  Future pickUpOrder({
    required model.Order order,
  }) async {
    await firestore
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isPickup": true,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('sellers')
        .doc(order.shop.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isPickup": true,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('users')
        .doc(order.user.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isPickup": true,
      },
      SetOptions(merge: true),
    );
  }

  Future changeRiderLocation({
    required model.Order order,
    required LatLng location,
    required BuildContext context,
  }) async {
    final ap = context.read<AuthenticationProvider>();

    Rider rider = Rider(
      user: userModel.User(uid: ap.uid!, email: ap.email!, name: ap.name!),
      latitude: location.latitude,
      longitude: location.longitude,
    );

    double distance = Helper().calculateDistance(
      location.latitude,
      location.longitude,
      order.address.latitude,
      order.address.longitude,
    );

    if (distance <= 0.5) {
      await nearLocation(order: order);
    }

    await firestore
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "rider": rider.toMap(),
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('sellers')
        .doc(order.shop.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "rider": rider.toMap(),
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('users')
        .doc(order.user.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "rider": rider.toMap(),
      },
      SetOptions(merge: true),
    );
  }

  Future deliveredOrder({
    required model.Order order,
  }) async {
    await firestore
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isDelivered": true,
        "deliveredTime": DateTime.now().millisecondsSinceEpoch,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('sellers')
        .doc(order.shop.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isDelivered": true,
        "deliveredTime": DateTime.now().millisecondsSinceEpoch,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('users')
        .doc(order.user.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isDelivered": true,
        "deliveredTime": DateTime.now().millisecondsSinceEpoch,
      },
      SetOptions(merge: true),
    );
  }

  Future nearLocation({
    required model.Order order,
  }) async {
    order.isNear = true;
    await firestore
        .collection('riders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isNear": true,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('sellers')
        .doc(order.shop.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isNear": true,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection('users')
        .doc(order.user.uid)
        .collection('orders')
        .doc(order.id)
        .set(
      {
        "isNear": true,
      },
      SetOptions(merge: true),
    );
  }
}
