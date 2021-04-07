import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:profesional_app/AllWidgets/Divider.dart';

class MainScreen extends StatefulWidget {

  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    /*String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address :: " + address);

    initGeoFireListner();

    uName = userCurrentInfo.name;

    AssistantMethods.retrieveHistoryInfo(context);*/
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    //createIconMarker();
    return Scaffold(
      key: scaffoldKey,
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
                          Text("Nombre de perfil", style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),),
                          //Text(uName, style: TextStyle(fontSize: 16.0, fontFamily: "Brand Bold"),),
                          SizedBox(height: 6.0,),
                          GestureDetector(
                              onTap: ()
                              {
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileTabPage()));
                              },
                              child: Text("Visitar perfil")
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              DividerWidget(),

              SizedBox(height: 12.0,),

              //Drawer Body Contrllers
              GestureDetector(
                onTap: ()
                {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> HistoryScreen()));
                },
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text("Historia", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileTabPage()));
                },
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Visitar Perfil", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutScreen()));
                },
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text("Acerca de", style: TextStyle(fontSize: 15.0),),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  //FirebaseAuth.instance.signOut();
                  //Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Cerrar Sesion", style: TextStyle(fontSize: 15.0),),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap, top: 25.0),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            //polylines: polylineSet,
            //markers: markersSet,
            //circles: circlesSet,
            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
          ),

          //HamburgerButton for Drawer
          Positioned(
            top: 36.0,
            left: 22.0,
            child: GestureDetector(
              onTap: ()
              {
                /*if(drawerOpen)
                {
                  scaffoldKey.currentState.openDrawer();
                }
                else
                {
                  resetApp();
                }*/
                scaffoldKey.currentState.openDrawer();
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
                  //child: Icon((drawerOpen) ? Icons.menu : Icons.close, color: Colors.black,),
                  child: Icon( Icons.menu, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          //Search Ui
          /*Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              //vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                //height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
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
                      Text("Hi there,", style: TextStyle(fontSize: 12.0),),
                      Text("Where to?", style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),),
                      SizedBox(height: 20.0),

                      GestureDetector(
                        onTap: () async
                        {
                          //var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));

                          /*if(res == "obtainDirection")
                          {
                            displayRideDetailsContainer();
                          }*/
                        },
                        child: Container(
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
                                  Text("Search Drop Off"),
                                ],
                              ),
                            ),
                          ),
                      ),

                      SizedBox(height: 24.0),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*Text(
                                Provider.of<AppData>(context).pickUpLocation != null
                                    ? Provider.of<AppData>(context).pickUpLocation.placeName
                                    : "Add Home",
                              ),*/
                              SizedBox(height: 4.0,),
                              Text("Your living home address", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 10.0),

                      DividerWidget(),

                      SizedBox(height: 16.0),

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
          ),*/

          //Ride Details Ui
          /*Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              //vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                //height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
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
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [

                      //bike ride
                      GestureDetector(
                        onTap: ()
                        {
                          //displayToastMessage("searching Bike...", context);

                          setState(() {
                            //state = "requesting";
                            //carRideType = "bike";
                          });
                          //displayRequestRideContainer();
                          //availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                          //searchNearestDriver();
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/bike.png", height: 70.0, width: 80.0,),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Bike", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold",),
                                    ),
                                    /*Text(
                                      //((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '') , style: TextStyle(fontSize: 16.0, color: Colors.grey,),
                                    ),*/
                                  ],
                                ),
                                Expanded(child: Container()),
                                /*Text(
                                  ((tripDirectionDetails != null) ? '\$${(AssistantMethods.calculateFares(tripDirectionDetails))/2}' : ''), style: TextStyle(fontFamily: "Brand Bold",),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0,),
                      Divider(height: 2.0, thickness: 2.0,),
                      SizedBox(height: 10.0,),

                      //uber-go ride
                      GestureDetector(
                        onTap: ()
                        {
                          //displayToastMessage("searching Uber-Go...", context);

                          /*setState(() {
                            state = "requesting";
                            carRideType = "uber-go";
                          });
                          displayRequestRideContainer();
                          availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                          searchNearestDriver();*/
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/ubergo.png", height: 70.0, width: 80.0,),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Uber-Go", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold",),
                                    ),
                                    /*Text(
                                      ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '') , style: TextStyle(fontSize: 16.0, color: Colors.grey,),
                                    ),*/
                                  ],
                                ),
                                Expanded(child: Container()),
                                /*Text(
                                  ((tripDirectionDetails != null) ? '\$${AssistantMethods.calculateFares(tripDirectionDetails)}' : ''), style: TextStyle(fontFamily: "Brand Bold",),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0,),
                      Divider(height: 2.0, thickness: 2.0,),
                      SizedBox(height: 10.0,),

                      //uber-x ride
                      GestureDetector(
                        onTap: ()
                        {
                          /*displayToastMessage("searching Uber-X...", context);

                          setState(() {
                            state = "requesting";
                            carRideType = "uber-x";
                          });
                          displayRequestRideContainer();
                          availableDrivers = GeoFireAssistant.nearByAvailableDriversList;
                          searchNearestDriver();*/
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/uberx.png", height: 70.0, width: 80.0,),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Uber-X", style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold",),
                                    ),
                                    /*Text(
                                      ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : '') , style: TextStyle(fontSize: 16.0, color: Colors.grey,),
                                    ),*/
                                  ],
                                ),
                                Expanded(child: Container()),
                                /*Text(
                                  ((tripDirectionDetails != null) ? '\$${(AssistantMethods.calculateFares(tripDirectionDetails))*2}' : ''), style: TextStyle(fontFamily: "Brand Bold",),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0,),
                      Divider(height: 2.0, thickness: 2.0,),
                      SizedBox(height: 10.0,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            //Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black54,),
                            SizedBox(width: 16.0,),
                            Text("Cash"),
                            SizedBox(width: 6.0,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16.0,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),*/

          //Cancel Ui
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              //height: requestRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),

                    SizedBox(
                        width: double.infinity,
                        /*child: ColorizeAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: [
                            "Requesting a Ride...",
                            "Please wait...",
                            "Finding a Driver...",
                          ],
                          textStyle: TextStyle(
                            fontSize: 55.0,
                            fontFamily: "Signatra"
                          ),
                          colors: [
                            Colors.green,
                            Colors.purple,
                            Colors.pink,
                            Colors.blue,
                            Colors.yellow,
                            Colors.red,
                          ],
                          textAlign: TextAlign.center,
                          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                        ),*/
                      ),

                    SizedBox(height: 22.0,),

                    GestureDetector(
                      onTap: ()
                      {
                        /*cancelRideRequest();
                        resetApp();*/
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.0),
                          border: Border.all(width: 2.0, color: Colors.grey[300]),
                        ),
                        child: Icon(Icons.close, size: 26.0,),
                      ),
                    ),

                    SizedBox(height: 10.0,),

                    Container(
                      width: double.infinity,
                      child: Text("Cancel Ride", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0),),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Display Assisned Driver Info
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0.5,
                    blurRadius: 16.0,
                    color: Colors.black54,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              //height: driverDetailsContainerHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0,),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      /*children: [
                        Text(rideStatus, textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),),
                      ],*/
                    ),

                    SizedBox(height: 22.0,),

                    Divider(height: 2.0, thickness: 2.0,),

                    SizedBox(height: 22.0,),

                    //Text(carDetailsDriver, style: TextStyle(color: Colors.grey),),

                    //Text(driverName, style: TextStyle(fontSize: 20.0),),

                    SizedBox(height: 22.0,),

                    Divider(height: 2.0, thickness: 2.0,),

                    SizedBox(height: 22.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //call button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(24.0),
                            ),
                            onPressed: () async
                            {
                              //launch(('tel://${driverphone}'));
                            },
                            color: Colors.black87,
                            child: Padding(
                              padding: EdgeInsets.all(17.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Call Driver   ", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                  Icon(Icons.call, color: Colors.white, size: 26.0,),
                                ],
                              ),
                            ),
                          ),
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