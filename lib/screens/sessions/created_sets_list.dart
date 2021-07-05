import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/created_settile.dart';

class CreatedSetsList extends StatefulWidget {

  @override
  _CreatedSetsListState createState() => _CreatedSetsListState();
}

class _CreatedSetsListState extends State<CreatedSetsList> {
  @override
  Widget build(BuildContext context) {
    final sets = Provider.of<List<Sets>>(context) ?? [];

    return ListView.builder(
      itemCount: sets.length,
      itemBuilder: (context, index) {
        return CreatedSetTile(sets: sets[index],);
      },
    );
  }
}
