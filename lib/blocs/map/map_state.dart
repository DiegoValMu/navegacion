part of 'map_bloc.dart';

class MapState extends Equatable {

  final bool isMapInitialized;
  final bool isfollowingUser;
  final bool showMyRoute;

  //polylines
  final Map<String, Polyline> polylines;


  const MapState({
    this.showMyRoute = true,  
    Map<String, Polyline>? polylines,
    this.isMapInitialized = false, 
    this.isfollowingUser = false
  }): polylines = polylines ?? const {};


  MapState copyWith({
    bool? isMapInitialized,
    bool? isfollowingUser,
    bool? showMyRoute,
    Map<String, Polyline>? polylines
  }) => MapState(
    isMapInitialized: isMapInitialized ?? this.isMapInitialized,
    isfollowingUser: isfollowingUser ?? this.isfollowingUser,
    polylines: polylines ?? this.polylines,
    showMyRoute: showMyRoute ?? this.showMyRoute
  );

  @override
  List<Object> get props => [isMapInitialized, isfollowingUser, polylines, showMyRoute];
}

