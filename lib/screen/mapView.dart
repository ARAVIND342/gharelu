import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gharelu/config/location_Provider.dart';

class MapView extends StatefulWidget {

  //static const String id = 'map-page';

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  LatLng currentLocation;
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    final locationInfo = Provider.of<LocationProviderService>(context);

    setState(() {
      currentLocation = LatLng(locationInfo.latitude, locationInfo.longitude);
    });

    void onCreated(GoogleMapController controller){
      setState(() {
        _mapController = controller;
      });
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 14.4746,
            ),
              zoomControlsEnabled: false,
              minMaxZoomPreference: MinMaxZoomPreference(
                1.5, 20.8,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove: (CameraPosition position){
                locationInfo.onCameraMove(position);
              },
              onMapCreated: onCreated,
              onCameraIdle: (){
                locationInfo.getMoveCamera();
              },

            ),
          ],
        ),
      ),
    );
  }
}
