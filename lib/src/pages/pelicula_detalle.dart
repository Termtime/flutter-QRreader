import 'package:flutter/material.dart';
import 'package:peliculas/src/modelos/actores_model.dart';
import 'package:peliculas/src/modelos/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  
  
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10,),
                _posterTitulo(pelicula, context),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _castPelicula(pelicula),
              ]
            ),
          )
        ],
      )
    );
  }

  Widget _crearAppbar(Pelicula pelicula)
  {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigo,
      expandedHeight: 150,
      floating:true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
        pelicula.title,
        style : TextStyle(color: Colors.white,fontSize: 12),
        overflow: TextOverflow.ellipsis

        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(pelicula.getPosterImg()),
                height: 150,
              ),
            ),
          ),
          SizedBox(width: 20,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead,  overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _descripcion(Pelicula pelicula)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _castPelicula(Pelicula pelicula)
  {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData)
        {
          return _crearActoresPageView(snapshot.data);
        }
        else
        {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores)
  {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actores.length,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemBuilder: (context, index) {
          return _actorTarjeta(actores[index], context);
        }
      ),
    );
  }

  Widget _actorTarjeta(Actor actor, BuildContext context)
  {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height:130,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            style: Theme.of(context).textTheme.subtitle,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
