import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/DataHandler/appdata.dart';
import 'package:rider_app/assistents/requestassistents.dart';
import 'package:rider_app/configMaps.dart';
import 'package:rider_app/models/placepredictions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
{
  TextEditingController pickuptextEditingController = TextEditingController();
  TextEditingController dropofftextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context)
  {
    String placeAddress = Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    pickuptextEditingController.text = placeAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(



            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Icon(
                        Icons.arrow_back
                  ),
                      ),
                      Center(
                        child: Text("Set Drop off," style: TextStyle(fontSize: 18.0), ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Image.asset("images/posimarker.png", height: 16.0, width: 16.0,),


                      SizedBox(width: 18.0,),


                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickuptextEditingController,
                              decoration: InputDecoration(
                                hintText: "Pickup Location"
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),


                      SizedBox(width: 18.0,),


                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val)
                              {
                                findPlace(val);
                              },
                              controller: dropofftextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?"
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
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
        ],
      ),
    );
  }


  void findPlace(String placeName) async
  {
   if(placeName.length >1)
   {
     //place api
     String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapkey&sessiontoken=1234567890&components=country:in";

     var res = await RequestAssistant.getRequest(autoCompleteUrl);
     if(res =="failed")
     {
       return;
     }
     //print("Places Prediction Response :: ");
     //print(res);

     if(res["status"] == "ok")
     {
       var predictions = res["predictions"];

       var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();

       setState(() {
         placePredictionList = placesList;
       });
     }
   }
  }
}


class PredictionTile extends StatelessWidget
{
  final PlacePredictions placePredictions;

  PredictionTile({Key? key, this.placePredictions}) : super(key: key);


  @override
  Widget build(BuildContext context)
  {
    return Container(
      child: Column(
        children: [
          SizedBox(width: 10.0,),
           Row(
          children: [
            Icon(Icons.add_location),
            SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(placePredictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                  SizedBox(height: 3.0,),
                  Text(placePredictions.secondary_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0, color:Colors.grey),),
                ],
              ),
            )
          ],
        ),
          SizedBox(width: 10.0,),
        ],
      ),
    );
  }
}
