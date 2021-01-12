import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/modelos/actores_model.dart';
import 'package:peliculas/src/modelos/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider{

  String _apiKey = 'a7e6ee73e89238874c2e6eb5c09c341e';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;
  List<Pelicula> _populares = new List();
  final _popularesStreamController = new StreamController<List<Pelicula>>.broadcast();

  //getter
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  //getter
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams()
  {
    _popularesStreamController?.close();
  }
  
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async
  {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }
  Future<List<Pelicula>> getEnCines() async
  {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apiKey,
      'language' : _language,
    });

    return await _procesarRespuesta(url);
  }

  void getPopulares() async
  {
    if(_cargando)
      return;
    _cargando = true;  
    _popularesPage++;
    final url = Uri.https(_url, "3/movie/popular", {
      'api_key' : _apiKey,
      'language' : _language,
      'page' : _popularesPage.toString(),
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares); // añadimos informacion al sink
    _cargando = false;
  } 

  Future<List<Actor>> getCast( String idPelicula) async
  {
    final url = Uri.https(_url, '3/movie/$idPelicula/credits', {
      'api_key' : _apiKey,
      'language' : _language,
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;

    
  }

  Future<List<Pelicula>> buscarPelicula(String query) async
  {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apiKey,
      'language' : _language,
      'query' : query,
    });

    return await _procesarRespuesta(url);
  }
}