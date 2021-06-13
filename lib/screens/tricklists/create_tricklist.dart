import 'package:flutter/material.dart';

class Create_TrickList extends StatefulWidget {

  @override
  _Create_TrickListState createState() => _Create_TrickListState();
}

class _Create_TrickListState extends State<Create_TrickList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Create a tricklist'),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(
                Icons.save,
                color: Colors.grey[100],
              ),
              label: Text(
                'Save',
                style: TextStyle(
                  color: Colors.grey[100],
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Text('create a list'),
    );
  }
}