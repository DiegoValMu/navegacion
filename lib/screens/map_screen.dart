import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navegacion/blocs/blocs.dart';
import 'package:navegacion/views/views.dart';
import 'package:navegacion/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();

    final locationBloc = BlocProvider.of<LocationBloc>(context);

    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState.lastKnowlocation == null){
            return const Center(child: Text('Espere por favor...'));
          }
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {

              Map<String, Polyline> polylines = Map.from( mapState.polylines );
              if ( !mapState.showMyRoute ){
                polylines.removeWhere((key, value) => key == 'myRoute');
              }
              if ( !mapState.inRoute ){
                polylines.removeWhere((key, value) => key == 'route');
              }

              return SingleChildScrollView(
                child: Stack(
                  children: [
                    MapView(
                      initialLocation: locationState.lastKnowlocation!,
                      polylines: polylines.values.toSet(),
                      markers: mapState.markers.values.toSet(),
                    ),
                    
                    // Botón de cancelar ruta en la esquina superior izquierda
                    !mapState.inRoute
                    ? Container()
                    : const Positioned(
                      top: 50,
                      left: 20, // Posición en la esquina superior izquierda
                      child: BtnCancelRoute(),
                    ),
                    
                    const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CustomSearchBar(),
                    ),
                    
                    const ManualMarker()
                  ],
                ),
              );
            },
          );
      }),
      
      // Botones en la esquina superior derecha
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 15), // Añadimos espacio para evitar superposición con BtnCancelRoute
          BtnCurrentLocation(), 
          BtnFollowUser(),
          BtnToggleUserRoute()
        ],
      ),
    );
  }
}
