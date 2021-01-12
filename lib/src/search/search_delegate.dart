import 'package:flutter/material.dart';
import 'package:peliculas/src/modelos/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:flutter/scheduler.dart';

class PeliculaSearch extends SearchDelegate
{

  final peliculasProvider = new PeliculasProvider();

  final peliculas = [
    'Spiderman',
    'AquaMan',
    'CaballoMan',
    'IronMan',
    'Capitan America',
  ];
  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];


  @override
  List<Widget> buildActions(BuildContext context) {
    //las acciones de nuestro appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if(query.isEmpty)
      return Container();
    
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData)
        {
          final peliculas = snapshot.data;

          return ListView.builder(
            itemCount: peliculas.length,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(peliculas[i].getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(peliculas[i].title),
                subtitle: Text(peliculas[i].originalTitle),
                onTap: (){
                  close(context, null);
                  peliculas[i].uniqueId = '${peliculas[i].uniqueId}-busqueda';
                  timeDilation = 1.5;
                  Navigator.pushNamed(context, 'detalle', arguments: peliculas[i]);
                },
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );






    // final listaSugerida = (query.isEmpty)
    // ? peliculasRecientes //si esta vacio
    // : peliculas.where(  //si no esta vacio
    //   (p) => p.toLowerCase().startsWith(query.toLowerCase())
    // ).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text( listaSugerida[i]),
    //       onTap: (){
            
    //       },
    //     );
    //   }
    // );
  }

}