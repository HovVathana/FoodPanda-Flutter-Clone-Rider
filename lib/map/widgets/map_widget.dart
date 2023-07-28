import 'package:flutter/material.dart';
import 'package:foodpanda_rider/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final LatLng latLng;
  final LatLng destination;
  final List<LatLng> polylineCoordinates;
  final Function(CameraPosition) onCameraMove;
  final VoidCallback onCameraIdle;
  final VoidCallback markerOnTap;
  final GoogleMapController? mapController;
  final Function(GoogleMapController) onMapCreated;
  final BitmapDescriptor latLngIcon;
  final BitmapDescriptor destinationIcon;

  MapWidget({
    Key? key,
    required this.latLng,
    required this.onCameraMove,
    required this.onCameraIdle,
    required this.mapController,
    required this.onMapCreated,
    required this.destination,
    required this.polylineCoordinates,
    required this.markerOnTap,
    required this.latLngIcon,
    required this.destinationIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: 17,
      ),
      markers: {
        Marker(
          markerId: MarkerId("source"),
          position: latLng,
          icon: latLngIcon,
        ),
        Marker(
          markerId: MarkerId("destination"),
          position: destination,
          icon: destinationIcon,
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: polylineCoordinates,
          color: scheme.primary,
          width: 6,
        ),
      },
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      compassEnabled: false,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      buildingsEnabled: true,
      // trafficEnabled: true,
      onMapCreated: onMapCreated,
      onCameraMove: onCameraMove,
      onCameraIdle: onCameraIdle,
    );
  }
}
