import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/modelos/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> elementos;
  CardSwiper({ @required this.elementos});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;
    

    return Container(
      padding: EdgeInsets.only(top:20),
      
      child: Swiper(
        itemBuilder: (BuildContext context,int index){

          elementos[index].uniqueId = '${elementos[index].id}-grande';

          Hero tarjeta = Hero(
            tag: elementos[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(elementos[index].getPosterImg()),
                placeholder: AssetImage('assets/img/loading.gif'),
                fit: BoxFit.cover,
              )
            ),
          );

          return GestureDetector(
            child: tarjeta,
            onTap: (){
              timeDilation = 1.5;
              Navigator.pushNamed(context, 'detalle', arguments: elementos[index]);
            },
          );
          
        },
        layout: SwiperLayout.STACK,
        itemCount: elementos.length,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.6,

        // pagination: SwiperPagination(),
        // control: SwiperControl(),
      ),
    );

    
  }
}