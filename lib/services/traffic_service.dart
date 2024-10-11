import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:navegacion/services/services.dart';

import '../models/models.dart';

class TrafficService {

  final Dio _dioTraffic;
  final Dio _dioPlaces;

  final String _baseTrafficUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  final String _basePlacesUrl = 'https://api.mapbox.com/search/geocoding/v6/reverse';


  TrafficService()
    : _dioTraffic = Dio()..interceptors.add( TrafficInterceptor() ),
      _dioPlaces = Dio()..interceptors.add( PLacesInterceptor() );


  Future<TrafficResponse> getCoorsStartToEnd( LatLng start, LatLng end ) async {


    final coorsString = '${ start.longitude },${ start.latitude };${ end.longitude },${ end.latitude }';
    final url = '$_baseTrafficUrl/driving/$coorsString';

    final resp = await _dioTraffic.get(url);

    print(resp);

    final data = TrafficResponse.fromMap(resp.data);
    
    return data;

  }

  Future getResultsByQuery( LatLng proximity, String query ) async {

    if( query.isEmpty ) return [];

    final url = '$_basePlacesUrl/forward';

    final resp = await _dioPlaces.get(url, queryParameters: {
      'q': query,
      'proximity': '${ proximity.longitude },${ proximity.latitude}'
    });


    return [];
  }



}