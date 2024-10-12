import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navegacion/blocs/blocs.dart';
import 'package:navegacion/delegates/delegates.dart';
import 'package:navegacion/models/models.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return state.displayManualMarker
        ? const SizedBox()
        : FadeInDown(
          duration: const Duration( milliseconds:  300 ),
          child: const _CustomSearchBarBody()
          );
      },
    );
  }
}

class _CustomSearchBarBody extends StatelessWidget {
  const _CustomSearchBarBody({super.key});

  void onSearchResult(BuildContext context, SearchResult result) async {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);

    if (result.manual == true) {
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }

    if ( result.position != null ) {

      final start = locationBloc.state.lastKnowlocation;
      if( start == null ) return;

      final end = result.position;

      final destination = await searchBloc.getCoorsStartToEnd( start , end!);
      await mapBloc.drawRoutePolyline(destination);
    }

    //todo: revisar si tenemos result.position
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: GestureDetector(
          onTap: () async {
            final result = await showSearch(
                context: context, delegate: SearchDestinationDelegate());
            if (result == null) return;

            onSearchResult(context, result);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 5))
                ]),
            child: const Text('¿Donde quieres ir?',
                style: TextStyle(color: Colors.black87)),
          ),
        ),
      ),
    );
  }
}
