import 'package:flutter/material.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xffad0000),
        elevation: 0.0,
        title: Text('Sign in'),
        centerTitle: true,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.grey[100],
            ),
            label: Text(
              "Register",
              style: TextStyle(
                  color: Colors.grey[100],
              ),
            ),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'email',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffad0000), width: 2.0),
                    ),
                  ),
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'password',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffad0000), width: 2.0),
                    ),
                  ),
                  validator: (val) => val.length < 6 ? 'Enter a password +6 characters long' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 25.0,),
                ElevatedButton(
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 16,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xffad0000)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null) {
                        setState(() {
                            error = 'Could not sign in. It may be because you wrote an invalid email or password';
                            loading = false;
                          }
                        );
                        
                      }
                    }
                  },
                ),
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}