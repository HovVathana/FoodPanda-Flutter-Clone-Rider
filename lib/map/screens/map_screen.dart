import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:foodpanda_rider/finish_deliver/screens/finish_deliver_screen.dart';
import 'package:foodpanda_rider/home/controllers/order_controller.dart';
import 'package:foodpanda_rider/map/widgets/bottom_container.dart';
import 'package:foodpanda_rider/map/widgets/map_widget.dart';
import 'package:foodpanda_rider/models/order.dart';

import 'package:foodpanda_rider/providers/location_provider.dart';
import 'package:foodpanda_rider/widgets/ficon_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final Order order;
  static const String routeName = '/map-screen';

  const MapScreen({super.key, required this.order});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  OrderController orderController = OrderController();
  Order? order;
  GoogleMapController? mapController;
  LatLng? latLng;
  LatLng? destination;
  CameraPosition? cameraPosition;
  List<LatLng> polylineCoordinates = [];
  bool isBottomContainer = true;
  Timer? timer;

  BitmapDescriptor shopIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor riderIcon = BitmapDescriptor.defaultMarker;

  getData() async {
    order = widget.order;

    final lp = context.read<LocationProvider>();

    await lp.getCurrentLocation();

    if (!widget.order.isPickup) {
      latLng = lp.latitude != null && lp.longitude != null
          ? LatLng(lp.latitude!, lp.longitude!)
          : const LatLng(11, 104);
      destination =
          LatLng(widget.order.shop.latitude, widget.order.shop.longitude);
    } else {
      latLng = LatLng(widget.order.shop.latitude, widget.order.shop.longitude);
      destination =
          LatLng(widget.order.address.latitude, widget.order.address.longitude);
      timer = Timer.periodic(
        const Duration(seconds: 10),
        (_) => trackLiveLocation(),
      );
    }

    cameraPosition = CameraPosition(target: latLng!);

    await getPolyline();

    setState(() {});
  }

  trackLiveLocation() async {
    final lp = context.read<LocationProvider>();
    order = widget.order;

    await lp.getCurrentLocation();
    LatLng location = LatLng(lp.latitude!, lp.longitude!);
    await orderController.changeRiderLocation(
        order: order!, location: location, context: context);
    print('location ${lp.latitude} ${lp.longitude}');
    setState(() {});
  }

  getPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCG2YHIuPJYMOJzS6wSw5eZ0dTYXnhZFLs',
      PointLatLng(latLng!.latitude, latLng!.longitude),
      PointLatLng(destination!.latitude, destination!.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
    }
  }

  pickUpHandler() async {
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => trackLiveLocation(),
    );
    await orderController.pickUpOrder(order: order!);
    order!.isPickup = true;
    latLng = LatLng(widget.order.shop.latitude, widget.order.shop.longitude);
    destination =
        LatLng(widget.order.address.latitude, widget.order.address.longitude);
    polylineCoordinates = [];
    await getPolyline();
    setState(() {});
  }

  deliverHandler() async {
    timer?.cancel();
    await orderController.deliveredOrder(order: order!);
    setState(() {});
    Navigator.pushReplacementNamed(
      context,
      FinishDeliverScreen.routeName,
      arguments: FinishDeliverScreen(
        price: order!.deliveryPrice,
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void addCustomIcon() async {
    final Uint8List shopByte =
        await getBytesFromAsset('assets/images/location_shop_marker.png', 100);

    final Uint8List riderByte =
        await getBytesFromAsset('assets/images/location_rider_marker.png', 100);

    final Uint8List userByte =
        await getBytesFromAsset('assets/images/location_user_marker.png', 100);

    shopIcon = BitmapDescriptor.fromBytes(shopByte);
    riderIcon = BitmapDescriptor.fromBytes(riderByte);

    userIcon = BitmapDescriptor.fromBytes(userByte);

    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    getData();
    addCustomIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Colors.white,
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                    children: [
                      latLng != null && cameraPosition != null
                          ? MapWidget(
                              mapController: mapController,
                              latLng: latLng!,
                              destination: destination!,
                              latLngIcon:
                                  !order!.isPickup ? riderIcon : shopIcon,
                              destinationIcon:
                                  !order!.isPickup ? userIcon : userIcon,
                              polylineCoordinates: polylineCoordinates,
                              onMapCreated: (GoogleMapController controller) {
                                setState(() {
                                  mapController = controller;
                                });
                              },
                              onCameraMove: (CameraPosition cp) {
                                setState(() {
                                  isBottomContainer = false;
                                  cameraPosition = cp;
                                });
                              },
                              onCameraIdle: () {
                                setState(() {
                                  isBottomContainer = true;
                                });
                              },
                              markerOnTap: () {},
                            )
                          : const SizedBox(),
                      // Center(
                      //     child: Icon(
                      //   Icons.location_on_rounded,
                      //   color: scheme.primary,
                      //   size: 40,
                      // )),
                    ],
                  ),
                ),
                order != null
                    ? isBottomContainer
                        ? Positioned(
                            bottom: 40,
                            left: 20,
                            right: 20,
                            child: BottomContainer(
                              order: order!,
                              pickUpHandler: pickUpHandler,
                              deliverHandler: deliverHandler,
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
                Positioned(
                  top: 20,
                  left: 10,
                  child: FIconButton(
                    icon: const Icon(Icons.arrow_back_sharp),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
