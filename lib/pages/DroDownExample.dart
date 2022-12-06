import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

class DroDownExample extends StatefulWidget {
  @override
  _DroDownExample createState() => _DroDownExample();
}

class _DroDownExample extends State<DroDownExample> {
  String _myActivity;
  int valueSelected;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Formfield Example'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: DropDownFormField(
                  titleText: 'Categoría',
                  hintText: 'Seleccionar ...',
                  value: _myActivity,
                  onSaved: (value) {
                    setState(() {
                      _myActivity = value;
                      print(_myActivity);
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _myActivity = value;
                      print(_myActivity);
                    });
                  },
                  dataSource: [
                    {
                      "display": "Naturaleza",
                      "value": "1",
                    },
                    {
                      "display": "Abstracto",
                      "value": "2",
                    },
                    {
                      "display": "Walking",
                      "value": "3",
                    },
                    {
                      "display": "Swimming",
                      "value": "4",
                    },
                    {
                      "display": "Soccer Practice",
                      "value": "5",
                    },
                    {
                      "display": "Baseball Practice",
                      "value": "Baseball Practice",
                    },
                    {
                      "display": "Football Practice",
                      "value": "Football Practice",
                    },
                  ],
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
