import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navegacion/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  GoogleMapController? _mapController;

  MapBloc() : super(MapState()) {

    on<OnMapInitializedEvent>( _onInitMap);
  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {

    _mapController = event.controller;
    //_mapController?.animateCamera();

    _mapController!.setMapStyle( jsonEncode( wmc2MapTheme )  );
    emit( state.copyWith( isMapInitialized: true ) );

  }

  void moveCamera ( LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

}
