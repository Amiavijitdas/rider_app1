
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/assistents/requestassistents.dart';
import 'package:rider_app/configMaps.dart';
import 'package:rider_app/models/address.dart';

class AssistantMethod
{
  static Future<String> searchCoordinateAddress(Position position, conyext) async
  {
    String placeAddress = "";
    String url ="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    var response = await RequestAssistant.getRequest(url);
    if(response !="Failed!")
    {
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }
}