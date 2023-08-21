import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:odlay_services/AppFiles/Utility/_sharedPrefrencesValues.dart';
import 'package:odlay_services/AppFiles/Utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationPrompt extends StatelessWidget {
  final VoidCallback? onPressed;
  LocationPrompt(this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 232, 229, 229),
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
              child: Image.asset(
            "assets/business_location.png",
            fit: BoxFit.fill,
            width: 20,
            height: 20,
          )),
          Text("Your Location Permission",
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold))),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Text(
                  "To use your location to automatically see the latest jobs or service providers around your area, please allow Odlay Services to use your location when the application is open or running.",
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                    color: Colors.black,
                  )))),
          Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                  "Odlay Services will use your location to fetch the latest jobs or closest service providers around your area and will order them by distance from your location",
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                    color: Colors.black,
                  )))),
          Spacer(),
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Image.asset(
                "assets/ic_map-location.png",
                fit: BoxFit.fill,
                width: 150,
                height: 130,
              )),
          Spacer(),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(
                      // <-- Icon

                      Icons.camera_alt_outlined,
                      size: 0.0,
                    ),
                    label: Text(
                      'I Agree',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.orange[900],
                    )),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                width: double.infinity,
                child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: const Icon(
                      // <-- Icon

                      Icons.camera_alt_outlined,
                      size: 0.0,
                    ),
                    label: Text(
                      'No Thanks',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      primary: Colors.grey,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
