import 'package:flutter/material.dart';

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

  GridLayout({this.title, this.icon});
}

List<GridLayout> options = [
  GridLayout(title: 'Abstracto', icon: Icons.home),
  GridLayout(title: 'Arte', icon: Icons.email),
  GridLayout(title: 'Cine', icon: Icons.access_alarm),
  GridLayout(title: 'Fantasía', icon: Icons.account_balance_wallet),
  GridLayout(title: 'Horror', icon: Icons.backup),
  GridLayout(title: 'Naturaleza', icon: Icons.book),
  GridLayout(title: 'Tecnología', icon: Icons.camera_alt_rounded),
  GridLayout(title: 'Videojuegos', icon: Icons.person),
  GridLayout(title: 'Otros', icon: Icons.print),
];

class GridOptions extends StatelessWidget {
  final GridLayout layout;
  GridOptions({this.layout});
  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
