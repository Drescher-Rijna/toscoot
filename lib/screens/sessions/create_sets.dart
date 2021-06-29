import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/sessions/created_sets_list.dart';
import 'package:toscoot/services/database.dart';

class Create_Sets extends StatefulWidget {

  @override
  _Create_SetsState createState() => _Create_SetsState();
}

class _Create_SetsState extends State<Create_Sets> {

  final _formKey = GlobalKey<FormState>();

  String _currentTrick;
  String reps = '';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Sets>>.value(
      value: DatabaseService().sets,
      child: Scaffold(
          backgroundColor: Colors.grey[900],
            appBar: AppBar(
              title: Text('Create A Session'),
              centerTitle: true,
              backgroundColor: Colors.orange[900],
              elevation: 0.0,
            ),
            body:
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                  child: Column(
                    children: [
                      StreamBuilder<ActiveTricklist>(
                        stream: DatabaseService().activeTricklist,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {

                            ActiveTricklist activeTricklist = snapshot.data;

                            print(activeTricklist.tricks);

                            return Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Add new sets',
                                          style: TextStyle(
                                            color: Colors.grey[200],
                                            fontSize: 20.0
                                          ),
                                        ),
                                        
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 15.0,),                                    
                                                  DropdownButtonFormField(
                                                    dropdownColor: Colors.grey[900],
                                                    style: TextStyle(
                                                      color: Colors.grey[200],
                                                      fontSize: 18.0,
                                                    ),
                                                    value: _currentTrick ?? 'Select a trick',
                                                    items: activeTricklist.tricks.map((trick) {
                                                      return new DropdownMenuItem(
                                                        value: trick,
                                                        child: new Text(trick),
                                                      );
                                                    }).toList(),
                                                    onChanged: (val) => setState(() => _currentTrick = val),
                                                  ), 
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20.0,),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 15.0,),
                                                  TextFormField(
                                                    decoration: InputDecoration(
                                                      hintText: 'Reps',
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.orange[900], width: 2.0),
                                                      ),
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    validator: (val) => val.isEmpty ? 'Enter reps' : null,
                                                    onChanged: (val) {
                                                      setState(() => reps = val);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20.0,),
                                        TextButton.icon(
                                          icon: Icon(
                                            Icons.add,
                                            color: Colors.grey[100],
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.orange[900],
                                            padding: EdgeInsets.all(12.0),
                                          ),
                                          onPressed: () async {
                                            if(_formKey.currentState.validate()){
                                              await DatabaseService().updateSetsData(_currentTrick, int.parse(reps));     
                                            }
                                          },
                                          label: Text(
                                              'Add new set',
                                              style: TextStyle(
                                              color: Colors.grey[100],
                                              fontSize: 16.0
                                              ),
                                            ),
                                        ),
                                        
                                        
                                      ],
                                    ),
                                    
                                  );

                          } else {
                            print(snapshot.data);
                            return Text('fejl');
                          }

                        } 
                      ),
                      SizedBox(height: 30.0,),
                      Expanded(
                          
                          child: CreatedSetsList(),
                        ),
                    ],
                  ),
            ),
              ),
      ),
    );
  }
}