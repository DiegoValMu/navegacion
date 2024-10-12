import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navegacion/blocs/blocs.dart';
import 'package:navegacion/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {

SearchDestinationDelegate():super(
  searchFieldLabel: 'Buscar...'
);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){
          query = '';
        }, 
        icon: const Icon( Icons.clear ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        final result = SearchResult(cancel: true);
        close(context, result);
      }, 
      icon: const Icon( Icons.arrow_back));
  }


//Resultados de busqueda en el CustomSearchBar
  @override
  Widget buildResults(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity = BlocProvider.of<LocationBloc>(context).state.lastKnowlocation!;

    searchBloc.getPlacesByQuery( proximity, query );


    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
          itemBuilder: (context, i) {
            final place = places[i];
            return ListTile(
              title: Text( place.properties.name, style: const TextStyle( fontSize: 20) ),
              subtitle: Text( place.properties.placeFormatted),
              leading: const Icon ( Icons.place_outlined, color: Colors.black),
              onTap: (){
                final result = SearchResult(
                  cancel: false, 
                  manual: false,
                  position: LatLng( place.properties.coordinates.longitude, place.properties.coordinates.latitude),
                  name: place.properties.name,
                  description: place.properties.placeFormatted
                  );
                close(context, result);
              },
            );
          }, 
          separatorBuilder: ( context, i) => const Divider(), 
          itemCount: places.length);
      },
    );
  }

//Opcion para señalar ubicacion manualmente
  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon( Icons.location_on_outlined),
          title: const Text('Señalar la ubicación en el mapa'),
          onTap: (){
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);

          },
        )
      ],
    );
  }



}