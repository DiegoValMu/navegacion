import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navegacion/blocs/blocs.dart';
import 'package:navegacion/themes/themes.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {

  final LocationBloc locationBloc;
  GoogleMapController? _mapController;

  StreamSubscription<LocationState>? locationStateSubscription;

  MapBloc({
    required this.locationBloc
    }) : super(MapState()) {

    on<OnMapInitializedEvent>( _onInitMap);
    on<OnStartFollowingUserEvent>( _onStartFollowingUser );
    on<OnStopFollowingUserEvent>((event, emit) => emit( state.copyWith( isfollowingUser: false )));

    on<UpdateUserPolylineEvent>( _onPolylineNewPoint);

    on<OnToggleUserRoute>((event, emit) => emit( state.copyWith( showMyRoute:  !state.showMyRoute )));


    locationBloc.stream.listen((locationState) { 

      if (locationState.lastKnowlocation != null) {
        add( UpdateUserPolylineEvent( locationState.myLocationHistory ) );
      }

      if ( !state.isfollowingUser )return;
      if ( locationState.lastKnowlocation == null)return;
      
      moveCamera( locationState.lastKnowlocation! );

    });




  }

  void _onInitMap( OnMapInitializedEvent event, Emitter<MapState> emit) {

    _mapController = event.controller;
    //_mapController?.animateCamera();

    _mapController!.setMapStyle( jsonEncode( wmc2MapTheme )  );
    emit( state.copyWith( isMapInitialized: true ) );

  }

  void _onStartFollowingUser( OnStartFollowingUserEvent event, Emitter<MapState> emit){
    emit( state.copyWith( isfollowingUser: true)  );

    if( locationBloc.state.lastKnowlocation == null ) return;
    moveCamera(locationBloc.state.lastKnowlocation! );

  }

  void _onPolylineNewPoint (UpdateUserPolylineEvent event, Emitter<MapState> emit){
    final myRoute = Polyline(
      polylineId: PolylineId('value'),
      color: Colors.black,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      );

      final currentPolylines = Map<String, Polyline>.from( state.polylines );
      currentPolylines['myRoute'] = myRoute;
      emit (state.copyWith(polylines: currentPolylines));

  }


  void moveCamera ( LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.animateCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }

}
