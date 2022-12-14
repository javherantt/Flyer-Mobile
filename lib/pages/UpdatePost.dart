import 'dart:convert';
import 'dart:typed_data';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:masveterinarias_app/models/Publicacion.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:azstore/azstore.dart';

class UpdatePost extends StatefulWidget {
  final int idPublicacion;
  UpdatePost(this.idPublicacion);
  @override
  _UpdatePost createState() => _UpdatePost();
}

class _UpdatePost extends State<UpdatePost> {
  int id;
  bool isSelectedImage = false;
  String categoria, filenameUpload, views, timestamp;
  String imagePickerMessage = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[800],
                Colors.blue[400],
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detalles publicaci??n",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
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
                          return Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextField(
                                  controller: titleController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFE7EDEB),
                                    hintText: "T??tulo",
                                    prefixIcon: Icon(
                                      Icons.title,
                                      color: Colors.grey[600],
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextField(
                                  controller: descriptionController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFE7EDEB),
                                    hintText: "Descripci??n",
                                    prefixIcon: Icon(
                                      Icons.description,
                                      color: Colors.grey[600],
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        child: DropDownFormField(
                                          titleText: 'Categor??a',
                                          hintText: 'Seleccionar ...',
                                          value: categoria,
                                          onSaved: (value) {
                                            setState(() {
                                              categoria = value;
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              categoria = value;
                                            });
                                          },
                                          dataSource: [
                                            {
                                              "display": "Abstracto",
                                              "value": "1",
                                            },
                                            {
                                              "display": "Arte",
                                              "value": "4",
                                            },
                                            {
                                              "display": "Cine",
                                              "value": "5",
                                            },
                                            {
                                              "display": "Fantasia",
                                              "value": "6",
                                            },
                                            {
                                              "display": "Horror",
                                              "value": "7",
                                            },
                                            {
                                              "display": "Naturaleza",
                                              "value": "2",
                                            },
                                            {
                                              "display": "Tecnolog??a",
                                              "value": "8",
                                            },
                                            {
                                              "display": "Videojuegos",
                                              "value": "9",
                                            },
                                            {
                                              "display": "Otros",
                                              "value": "10",
                                            },
                                          ],
                                          textField: 'display',
                                          valueField: 'value',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Text(imagePickerMessage),
                                SizedBox(
                                  height: 30.0,
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        ),
      ),
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

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        isSelectedImage = true;
        imagePickerMessage = "??Imagen seleccionada!";
      });
    }
  }

  Future<Publicacion> _getPublicacion() async {
    var data = await http.get(Uri.parse(
        'https://flyer-api.azurewebsites.net/api/post/' +
            widget.idPublicacion.toString()));
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
    titleController.text = publicacion.title;
    descriptionController.text = publicacion.description;
    categoria = publicacion.tagId.toString();
    filenameUpload = publicacion.filename;
    views = publicacion.views.toString();
    timestamp = publicacion.timestamp;
    return publicacion;
  }

  void updatePublicacion(String title, description, filename) async {
    try {
      var response = await http.post(
          Uri.parse("https://flyer-api.azurewebsites.net/api/post/id=" +
              widget.idPublicacion.toString()),
          body: {
            "id": widget.idPublicacion.toString(),
            "userId": id.toString(),
            "tagId": categoria,
            "title": title,
            "description": description,
            "filename": filename,
            "views": views,
            "timestamp": timestamp
          });
      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> cargarImagen(File file) async {
    Uint8List bytes = file.readAsBytesSync();
    var storage = AzureStorage.parse(
        'DefaultEndpointsProtocol=https;AccountName=flyerimages;AccountKey=NKC/m3+n+HmF2KHfYOdIUAbPi0iwsuISgfATeIYRIeky/DVL4pNxnRqMSDU4wrJDaToHxQy2Y91b+AStpcjltQ==;EndpointSuffix=core.windows.net');
    try {
      await storage.putBlob(
        '/imagenes/' + Path.basename(file.path),
        bodyBytes: bytes,
        contentType: 'image/jpg',
      );
      filenameUpload = Path.basename(file.path);
    } catch (e) {
      print('exception: $e');
    }
  }
}
