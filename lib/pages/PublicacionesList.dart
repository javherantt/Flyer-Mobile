import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masveterinarias_app/models/Publicacion.dart';
import 'package:masveterinarias_app/pages/hotel_booking/training_screen.dart';

class PublicacionesList extends StatefulWidget {
  PublicacionesList({Key key}) : super(key: key);
  @override
  _Publicaciones createState() => _Publicaciones();
}

class _Publicaciones extends State<PublicacionesList> {
  Future<List<Publicacion>> _listadoRestau;
  Future<List<Publicacion>> _getRestaurantes() async {
    var response = await http
        .get(Uri.parse('https://flyer-api.azurewebsites.net/api/post'));

    List<Publicacion> _publicaciones = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData["data"]) {
        _publicaciones.add(Publicacion(
            item['id'],
            item['userId'],
            item['tagId'],
            item['title'],
            item['description'],
            item['filename'],
            item['views'],
            item['timestamp']));
      }
      return _publicaciones;
    } else {
      throw Exception("Falló la conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoRestau = _getRestaurantes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(title: Text('Publicaciones')),
        body: FutureBuilder(
          future: _listadoRestau,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 1,
                children: _ListPublicaciones(snapshot.data, context),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('No se encontraron resultados',
                      style: TextStyle(fontWeight: FontWeight.bold)));
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }
}

List<Widget> _ListPublicaciones(List<Publicacion> data, BuildContext context) {
  navigateToDetail(consulta) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TrainingScreen()));
  }

  List<Widget> listadoPublicaciones = [];
  for (var post in data) {
    listadoPublicaciones.add(Card(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () => navigateToDetail(post),
              child: Image.network(
                  'https://flyerimages.blob.core.windows.net/imagenes/' +
                      post.filename,
                  height: 120,
                  width: 140)),
        ),
        Flexible(
          child: RichText(
            overflow: TextOverflow.ellipsis,
            strutStyle: StrutStyle(fontSize: 12.0),
            text: TextSpan(
                style: TextStyle(color: Colors.black), text: post.title),
          ),
        ),
      ],
    )));
  }
  return listadoPublicaciones;
}
