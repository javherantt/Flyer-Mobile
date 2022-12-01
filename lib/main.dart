import 'package:masveterinarias_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:masveterinarias_app/pages/Cita.dart';
import 'package:masveterinarias_app/pages/Login.dart';
import 'package:masveterinarias_app/pages/Profile.dart';
import 'package:masveterinarias_app/pages/Registro.dart';
import 'package:masveterinarias_app/pages/hotel_booking/home_design_course.dart';
import 'package:masveterinarias_app/pages/PostList.dart';
import 'package:flutter_session/flutter_session.dart';

void main() => runApp(MyApp());
/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dynamic token = await FlutterSession().get('token');
  runApp(MaterialApp(home: token != '' ? HotelHomeScreen() : LoginPage()));
}
*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flyer',
      home: LoginPage(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
