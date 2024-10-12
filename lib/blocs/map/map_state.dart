part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isfollowingUser;
  final bool showMyRoute;

  //polylines
  final Map<String, Polyline> polylines;
  //markers
  final Map<String, Marker> markers;


  const MapState({
    this.showMyRoute = true,  
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers,
    this.isMapInitialized = false, 
    this.isfollowingUser = false
  }): polylines = polylines ?? const {},
      markers = markers ?? const {};


  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines,
    Map<String, Marker>? markers
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isfollowingUser: isfollowingUser ?? this.isfollowingUser,
    polylines: polylines ?? this.polylines,
    showMyRoute: showMyRoute ?? this.showMyRoute,
    markers: markers ?? this.markers
  );

  @override
  List<Object> get props => [ isMapInitialized, isfollowingUser, polylines, showMyRoute, markers ];
}

