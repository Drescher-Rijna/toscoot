import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsTrickTile extends StatefulWidget {

  final String trick;
  DetailsTrickTile(this.trick);

  @override
  _DetailsTrickTileState createState() => _DetailsTrickTileState(trick);
}

class _DetailsTrickTileState extends State<DetailsTrickTile> {

  final String trick;
  _DetailsTrickTileState(this.trick);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        color: Color(0xffe6e6e6),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)),
        elevation: 1,
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                trick,
                style: TextStyle(
                  color: Color(0xff1a1a1a),
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}