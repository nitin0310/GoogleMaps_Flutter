import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static final CameraPosition initialLocation = CameraPosition(target: LatLng(28.7041, 77.1025),zoom: 6);
  Completer<GoogleMapController> controller = Completer();
  Position currentPosition;
  MapType mapType = MapType.normal;



  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    Position current = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = current;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.red[800],
        title: Text("Google maps",style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.satellite,color: Colors.white,),
        backgroundColor: Colors.red[800],
        onPressed: (){
          setState(() {
            if(mapType == MapType.normal){
              mapType = MapType.hybrid;
            }else{
              mapType = MapType.normal;
            }
          });
        },
      ),


      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(

          mapType: mapType,
          initialCameraPosition: currentPosition == null?initialLocation:CameraPosition(target: LatLng(currentPosition.latitude, currentPosition.longitude)),
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController gmapController){
            controller.complete(gmapController);
          },
          markers:{

            Marker(markerId: MarkerId('My location'),
            position: currentPosition == null?LatLng(28.7041, 77.1025):LatLng(currentPosition.latitude, currentPosition.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
            ),

          },
        ),
      ),
    );
  }
}
