import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masveterinarias_app/models/Publicacion.dart';
import 'package:masveterinarias_app/pages/hotel_booking/training_screen.dart';
import 'package:masveterinarias_app/pages/color_filters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicacionesList extends StatefulWidget {
  PublicacionesList({Key key}) : super(key: key);
  @override
  _Publicaciones createState() => _Publicaciones();
}

class _Publicaciones extends State<PublicacionesList> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Publicaciones')),
        body: Container(
          child: FutureBuilder(
            future: _getPublicaciones(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text('Cargando ...'),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        var route = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new DetallesPublicacion(snapshot.data[index].id),
                        );
                        Navigator.push(context, route);
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Ink.image(
                                  image: NetworkImage(
                                    'https://flyerimages.blob.core.windows.net/imagenes/' +
                                        snapshot.data[index].filename,
                                  ),
                                  height: 240,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  left: 16,
                                  child: Text(
                                    snapshot.data[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(16).copyWith(bottom: 0),
                              child: Text(
                                snapshot.data[index].description,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                DetallesPublicacion(
                                                    snapshot.data[index].id)));
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.black87,
                                  ),
                                  icon: Icon(Icons.remove_red_eye),
                                  label: Text('Ver'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<List<Publicacion>> _getPublicaciones() async {
    var data = await http
        .get(Uri.parse('https://flyer-api.azurewebsites.net/api/post'));
    var jsonData = json.decode(data.body);
    List<Publicacion> publicaciones = [];
    for (var item in jsonData) {
      Publicacion publicacion = Publicacion(
          item['id'],
          item['userId'],
          item['tagId'],
          item['title'],
          item['description'],
          item['filename'],
          item['views'],
          item['timestamp']);
      publicaciones.add(publicacion);
    }
    return publicaciones;
  }
}
//

//
//
class DetallesPublicacion extends StatefulWidget {
  final int publicacionId;
  DetallesPublicacion(this.publicacionId);
  @override
  _DetallesPublicacion createState() => _DetallesPublicacion();
}

class _DetallesPublicacion extends State<DetallesPublicacion> {
  int id;

  @override
  void initState() {
    super.initState();
    getId();
  }

  getId() async {
    SharedPreferences prefers = await SharedPreferences.getInstance();
    setState(() {
      id = prefers.getInt('id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          body: Container(
            child: FutureBuilder(
                future: _getPublicacion(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text('Cargando ...'),
                      ),
                    );
                  } else {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Ink.image(
                            image: NetworkImage(
                                'https://flyerimages.blob.core.windows.net/imagenes/' +
                                    snapshot.data.filename),
                            height: 300,
                            fit: BoxFit.fitWidth,
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text(snapshot.data.title),
                            subtitle: Text(
                              'by AUTHOR, ' + snapshot.data.timestamp,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              snapshot.data.description,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ));
  }

  Future<Publicacion> _getPublicacion() async {
    var data = await http.get(Uri.parse(
        'https://flyer-api.azurewebsites.net/api/post/' +
            widget.publicacionId.toString()));
    var jsonData = json.decode(data.body);
    Publicacion publicacion = Publicacion(
        jsonData['id'],
        jsonData['userId'],
        jsonData['tagId'],
        jsonData['title'],
        jsonData['description'],
        jsonData['filename'],
        jsonData['views'],
        jsonData['timestamp']);
    return publicacion;
  }
}
