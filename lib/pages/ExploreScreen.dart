import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masveterinarias_app/models/Publicacion.dart';
import 'package:masveterinarias_app/pages/PublicacionesList.dart';

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Stateless Widget")),
        body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            padding: EdgeInsets.all(10.0),
            children: List.generate(
              options.length,
              (index) => GridOptions(
                layout: options[index],
              ),
            ),
          ),
        ));
  }
}

class GridLayout {
  final String title;
  final IconData icon;
  int categoryId;

  GridLayout({this.title, this.icon, this.categoryId});
}

List<GridLayout> options = [
  GridLayout(title: 'Abstracto', icon: Icons.camera_outlined, categoryId: 1),
  GridLayout(title: 'Arte', icon: Icons.brush, categoryId: 4),
  GridLayout(title: 'Cine', icon: Icons.movie, categoryId: 5),
  GridLayout(title: 'Fantasía', icon: Icons.menu_book_rounded, categoryId: 6),
  GridLayout(title: 'Horror', icon: Icons.outlet, categoryId: 7),
  GridLayout(title: 'Naturaleza', icon: Icons.nature, categoryId: 2),
  GridLayout(title: 'Tecnología', icon: Icons.computer, categoryId: 8),
  GridLayout(title: 'Games', icon: Icons.videogame_asset, categoryId: 9),
  GridLayout(title: 'Otros', icon: Icons.view_list_rounded, categoryId: 10),
];

class GridOptions extends StatelessWidget {
  final GridLayout layout;
  GridOptions({this.layout});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    PublicacionesCategoria(layout.categoryId)));
      },
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                layout.icon,
                size: 40,
              ),
              Text(
                layout.title,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//

//
//
class PublicacionesCategoria extends StatefulWidget {
  final int categoriaId;
  PublicacionesCategoria(this.categoriaId);
  @override
  _PublicacionesCategoria createState() => _PublicacionesCategoria();
}

class _PublicacionesCategoria extends State<PublicacionesCategoria> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          body: Container(
            child: FutureBuilder(
                future: _getPublicaciones(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                  new DetallesPublicacion(
                                      snapshot.data[index].id),
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
                                  padding:
                                      EdgeInsets.all(16).copyWith(bottom: 0),
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
                                        var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new DetallesPublicacion(
                                                  snapshot.data[index].id),
                                        );
                                        Navigator.push(context, route);
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Colors.black87,
                                      ),
                                      icon: Icon(Icons.remove_red_eye),
                                      label: Text('Ver'),
                                    ), /*
                                    TextButton.icon(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          primary: Colors.red,
                                        ),
                                        icon: Icon(Icons.favorite),
                                        label: Text('Me gusta'))
                                        */
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ));
  }

  Future<List<Publicacion>> _getPublicaciones() async {
    var data = await http.get(Uri.parse(
        'https://flyer-api.azurewebsites.net/api/post/category/' +
            widget.categoriaId.toString()));
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
