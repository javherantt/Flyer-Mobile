import 'dart:typed_data';
import 'package:masveterinarias_app/pages/HomePage.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:azstore/azstore.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPost createState() => _AddPost();
}

class _AddPost extends State<AddPost> {
  int id;
  bool isSelectedImage = false;
  String categoria;
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
                        "Crear publicación",
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
                  child: Padding(
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
                            hintText: "Título",
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
                            hintText: "Descripción",
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
                                  titleText: 'Categoría',
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
                                      "display": "Tecnología",
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: Text("Seleccionar imagen"),
                        ),
                        Text(imagePickerMessage),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: isSelectedImage
                                ? () {
                                    cargarImagen(imageFile);
                                    postPublicacion(
                                        titleController.text.toString(),
                                        descriptionController.text.toString(),
                                        Path.basename(imageFile.path));
                                  }
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.blue[600],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text(
                                "Crear publicación",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
        imagePickerMessage = "¡Imagen seleccionada!";
      });
    }
  }

  void postPublicacion(String title, description, filename) async {
    try {
      var response = await http.post(
          Uri.parse("https://flyer-api.azurewebsites.net/api/post"),
          body: {
            "userId": id.toString(),
            "tagId": categoria,
            "title": title,
            "description": description,
            "filename": filename
          });
      if (response.statusCode == 200) {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new HomePage(),
        );
        Navigator.of(context).push(route);
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
    } catch (e) {
      print('exception: $e');
    }
  }
}
