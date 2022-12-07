import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:azstore/azstore.dart';
import 'package:path/path.dart' as Path;
import 'package:masveterinarias_app/pages/HomePage.dart';
import 'package:masveterinarias_app/pages/Login.dart';
import 'package:masveterinarias_app/pages/PostList.dart';
import 'package:masveterinarias_app/pages/PublicacionesList.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSelectedImage = false;
  String imagePickerMessage = "";
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
                        "Crear una cuenta",
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
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFE7EDEB),
                            hintText: "Email",
                            prefixIcon: Icon(
                              Icons.email,
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
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFE7EDEB),
                            hintText: "Username",
                            prefixIcon: Icon(
                              Icons.person,
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
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFE7EDEB),
                            hintText: "Contraseña",
                            prefixIcon: Icon(
                              Icons.lock,
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: Text("Imagen de perfil (Opcional)"),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () {
                              cargarImagen(imageFile);
                              postUser(
                                  emailController.text.toString(),
                                  usernameController.text.toString(),
                                  passwordController.text.toString(),
                                  Path.basename(imageFile.path));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.blue[600],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text(
                                "Crear Cuenta",
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

  void postUser(String email, username, password, filename) async {
    //String formatDate =
    //    DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
    try {
      var response = await http.post(
          Uri.parse("https://flyer-api.azurewebsites.net/api/user"),
          body: {
            "email": email,
            "username": username,
            "password": password,
            "image": filename,
            "role": ""
          });
      if (response.statusCode == 200) {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new LoginPage(),
        );
        Navigator.of(context).push(route);
      }
    } catch (e) {
      print(e);
    }
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
      print(Path.basename(file.path));
    } catch (e) {
      print('exception: $e');
    }
  }
}
