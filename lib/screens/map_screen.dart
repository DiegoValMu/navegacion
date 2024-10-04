import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navegacion/blocs/blocs.dart';
import 'package:navegacion/views/views.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  late LocationBloc locationBloc;

  @override
  void initState(){
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
        builder: (context, state){

          if (state.lastKnowlocation == null) return const Center(child: Text('Espere por favor...'));

          return SingleChildScrollView(
            child: Stack(
              children: [
                MapView( initialLocation: state.lastKnowlocation!,)
              ],
            ),
          );

        }),
    );
  }
}