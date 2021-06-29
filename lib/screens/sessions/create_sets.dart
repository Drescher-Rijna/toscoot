import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/screens/sessions/created_sets_list.dart';
import 'package:toscoot/services/database.dart';

class Create_Sets extends StatefulWidget {

  @override
  _Create_SetsState createState() => _Create_SetsState();
}

class _Create_SetsState extends State<Create_Sets> {

  final _formKey = GlobalKey<FormState>();

  String trick = '';
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
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Column(
                  children: [
                    Form(
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
                                    
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Trick',
                                        fillColor: Colors.white,
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.orange[900], width: 2.0),
                                        ),
                                      ),
                                      validator: (val) => val.isEmpty ? 'Enter a trick' : null,
                                      onChanged: (val) {
                                        setState(() => trick = val);
                                      },
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
                                await DatabaseService().updateSetsData(trick, int.parse(reps));     
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
                    ),
                    SizedBox(height: 30.0,),
                    Expanded(
                        
                        child: CreatedSetsList(),
                      ),
                  ],
                ),
            ),
      ),
    );
  }
}