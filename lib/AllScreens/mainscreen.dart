import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/appdata.dart';
import 'package:rider_app/assistents/assistenceMethod.dart';
import 'package:rider_app/devider.dart';

class MainScreen extends StatefulWidget
{
  static const String idScreen = "mainScreen";
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPadding0fMap = 0;

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition; LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethod.searchCoordinateAddress(position, context);
    print("This is your address ::" +address);
  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              //Drawer Header
              Container(
                height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                        SizedBox(width: 16.0,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Profile Name", style: TextStyle(fontSize: 16.0),),
                            SizedBox(height: 6.0,),
                            Text("visit profile"),
                          ],
                        )
                      ],
                    ),
                  ),
              ),

              DividerWidget(),
              SizedBox(height: 12.0,),

              //Drawer body controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text("Ride History", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.contacts),
                title: Text("Contact Us", style: TextStyle(fontSize: 15.0),),
              ),

            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPadding0fMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPadding0fMap = 300.0;
              });
              locatePosition();
            },
          ),


          //hamburgerbutton for drower
          Positioned(
            top: 45.0,
              left: 22.0,
            child: GestureDetector(
              onTap: ()
              {
                scaffoldkey.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),topRight: Radius.circular(18.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6.0),
                  Text("Hi there,", style: TextStyle(fontSize: 12.0), ),
                  Text("Where to Go?,", style: TextStyle(fontSize: 20.0), ),
                  SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.blueAccent,),
                          SizedBox(width: 10.0,),
                          Text("Search Drop Off")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 24.0),
                  Row(
                    children: [
                      Icon(Icons.home, color: Colors.grey,),
                      SizedBox(width: 12.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          Provider.of<AppData>(context).pickupLocation != null
                              ? Provider.of<AppData>(context).pickupLocation.placeName
                              :"Add Home"
                          ),
                          SizedBox(height: 4.0,),
                          Text("Your living home address", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10.0),
                  DividerWidget(),
                  SizedBox(width: 16.0),
                  Row(
                    children: [
                      Icon(Icons.work, color: Colors.grey,),
                      SizedBox(width: 12.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add Work"),
                          SizedBox(height: 4.0,),
                          Text("Your office address", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
