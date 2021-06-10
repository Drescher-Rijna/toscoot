import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/user.dart';
import 'package:toscoot/screens/authenticate/authenticate.dart';
import 'package:toscoot/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<MyUser>(context);
    print(user);
    
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }
    
  }
}