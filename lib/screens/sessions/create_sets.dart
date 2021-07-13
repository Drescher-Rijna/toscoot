import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/session.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/sessions/created_sets_list.dart';
import 'package:toscoot/screens/sessions/sessions.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/shared/loading.dart';

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

    return StreamProvider<List<CurrentSets>>.value(
      value: DatabaseService().currentSets,
      child: StreamBuilder<ActiveTricklist>(
        stream: DatabaseService().activeTricklist,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot != null) {
            ActiveTricklist activeTricklist = snapshot.data;
            return Scaffold(
              backgroundColor: Color(0xff121212),
                appBar: AppBar(
                  title: Text('Create A Session'),
                  centerTitle: true,
                  backgroundColor: Color(0xffbd0f15),
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
                      onPressed: () {
                        Navigator.pop(context, MaterialPageRoute(builder: (context) => Sessions()));
                      },
                    ),
                  ],
                ),
                body:
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                      child: Column(
                        children: [
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10,),
                                            Text(
                                              'Add new sets',
                                              style: TextStyle(
                                                color: Colors.grey[200],
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 15.0,),                                    
                                                      Container(
                                                        height: 60,
                                                        child: DropdownButton(
                                                          iconEnabledColor: Color(0xffbd0f15),
                                                          iconSize: 30,
                                                          dropdownColor: Colors.grey[900],
                                                          icon: Icon(Icons.arrow_drop_down),
                                                          hint: Text('Select a trick', style: TextStyle(color: Colors.grey[100], fontSize: 16.0),),
                                                         isExpanded: true,
                                                          value: _currentTrick,
                                                          items: activeTricklist.tricks.map((trick) {
                                                            return new DropdownMenuItem(
                                                              
                                                              value: trick,

                                                              child: Text( trick, 
                                                                  style: TextStyle(
                                                                    color: Colors.grey[100], 
                                                                    fontSize: 16.0),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) => setState(() => _currentTrick = val ),
                                                        ),
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
                                                          hintStyle: TextStyle(fontSize: 16.0),
                                                          fillColor: Colors.white,
                                                          filled: true,
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                                                          ),
                                                          focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(color: Color(0xffbd0f15), width: 2.0),
                                                          ),
                                                        ),
                                                        style: TextStyle(fontSize: 16),
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
                                backgroundColor: Color(0xffbd0f15),
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
          } else {
            return Loading();
          }
        }),
        
      );
  }
}