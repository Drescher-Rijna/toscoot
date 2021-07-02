import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/tricklist.dart';
import 'package:toscoot/screens/sessions/create_sets.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/shared/loading.dart';

class Create_Session extends StatefulWidget {

  @override
  _Create_SessionState createState() => _Create_SessionState();
}

class _Create_SessionState extends State<Create_Session> {
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  String title = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.grey[900],
          appBar: AppBar(
            title: Text('Create A Session'),
            centerTitle: true,
            backgroundColor: Colors.orange[900],
            elevation: 0.0,
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'First give your session a title:',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.grey[100]
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Title of your new session',
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange[900], width: 2.0),
                        ),
                      ),
                      validator: (val) => val.isEmpty ? 'Enter a title' : null,
                      onChanged: (val) {
                        setState(() => title = val);
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange[900],
                        padding: EdgeInsets.fromLTRB(13, 13, 13, 13)
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          setState(() => loading = true);
                          await DatabaseService().updateSessionData(title);
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => Create_Sets()));
                          setState(() => loading = false);
                        }
                      },
                      child: Text(
                        'Create session',
                        style: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 18.0
                        ),
                        ),
                    ), 
                  ],
                ),
                
              ),
            ),
          ),
      );
  }
}