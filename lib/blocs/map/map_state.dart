part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isfollowingUser;

  //polylines
  final Map<String, Polyline> polylines;


  const MapState( {
    Map<String, Polyline>? polylines,
    this.isMapInitialized = false, 
    this.isfollowingUser = false
  }): polylines = polylines ?? const {};


  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowingUser,
    Map<String, Polyline>? polylines
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isfollowingUser: isfollowingUser ?? this.isfollowingUser,
    polylines: polylines ?? const {}
  );

  @override
  List<Object> get props => [isMapInitialized, isfollowingUser, polylines];
}

