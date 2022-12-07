import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masveterinarias_app/models/Publicacion.dart';
import 'package:masveterinarias_app/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masveterinarias_app/pages/AddPost.dart';
import '../models/Usuario.dart';
import 'dart:convert';
import 'dart:async';

class ProfileTap extends StatefulWidget {
  ProfileTap({Key key}) : super(key: key);
  @override
  _ProfileTap createState() => _ProfileTap();
}

class _ProfileTap extends State<ProfileTap> {
  int id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 2),
            child: SizedBox(
              child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                  label: Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.black12)),
            ),
          )
        ],
        /*
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        */
      ),
      body: Column(children: [
        FutureBuilder(
          future: _getMyUserData(id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('Cargando ...'),
                ),
              );
            } else {
              return Container(
                color: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                "https://flyerimages.blob.core.windows.net/imagenes/" +
                                    snapshot.data.image),
                          ),
                          InkWell(
                            onTap: () {},
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.edit,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          snapshot.data.username,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "32",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Publicaciones",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    .copyWith(color: Colors.black54),
                              )
                            ],
                          )
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            var route = new MaterialPageRoute(
                              builder: (BuildContext context) => new HomePage(),
                            );
                            Navigator.push(context, route);
                          },
                          child: Text('Agregar publicación')),
                    ]),
              );
            }
          },
        ),
        Expanded(
          child: FutureBuilder(
            future: _getMyPosts(id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text('Cargando ...'),
                  ),
                );
              } else {
                return GridView.count(
                  crossAxisCount: 2,
                  children: _listPublicaciones(snapshot.data, context),
                );
              }
            },
          ),
        ),
      ]),
    );
  }

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

  Future<Usuario> _getMyUserData(int id) async {
    var data = await http.get(Uri.parse(
        'https://flyer-api.azurewebsites.net/api/user/' + id.toString()));
    var jsonData = json.decode(data.body);
    Usuario usuario = Usuario(jsonData['id'], jsonData['email'],
        jsonData['username'], jsonData['password'], jsonData['image']);
    return usuario;
  }

  Future<List<Publicacion>> _getMyPosts(int id) async {
    var data = await http.get(Uri.parse(
        'https://flyer-api.azurewebsites.net/api/post/user/' + id.toString()));
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

List<Widget> _listPublicaciones(List<Publicacion> data, BuildContext context) {
  List<Widget> publicaciones = [];
  MaterialPageRoute route;
  for (var publi in data) {
    publicaciones.add(Card(
        child: Column(
      children: [
        GestureDetector(
            onTap: () {},
            child: Image.network(
              'https://flyerimages.blob.core.windows.net/imagenes/' +
                  publi.filename,
              width: 210,
              height: 200,
            )),
        RichText(
          overflow: TextOverflow.ellipsis,
          strutStyle: StrutStyle(fontSize: 20.0),
          text: TextSpan(
              style: TextStyle(color: Colors.black), text: publi.title),
        ),
      ],
    )));
  }
  return publicaciones;
}
