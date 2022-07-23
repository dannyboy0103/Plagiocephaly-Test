
import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;

//import 'package:google_maps/google_maps.dart';

/*
class GoogleMap extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String htmlId = "7";

    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final latLang = LatLng(12.9007616, 77.6568832);
    //class to create a div element

    final mapOptions = MapOptions()
      ..zoom = 11
      ..tilt = 90
      ..center = latLang;
    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = "none";

    final map = GMap(elem, mapOptions);
    Marker(MarkerOptions()
      ..position = latLang
      ..map = map
      ..title = 'My position');
    Marker(MarkerOptions()
      ..position = LatLng(12.9557616, 77.7568832)
      ..map = map
      ..title = 'My position');
    return elem;
  });
  //creates a platform view for Flutter Web
  return HtmlElementView(
    viewType: htmlId,
  );
  }
}*/