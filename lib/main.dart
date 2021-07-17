import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toscoot/models/alertShow.dart';
import 'package:toscoot/models/results.dart';
import 'package:toscoot/models/user.dart';
import 'package:toscoot/screens/wrapper.dart';
import 'package:toscoot/services/auth.dart';
import 'package:toscoot/services/database.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await DatabaseService().userCollection.doc(FirebaseAuth.instance.currentUser.uid).get().then((value) {
    DatabaseService.ActiveID = value['ActiveID'];
  });

  print(DatabaseService.ActiveID);
  
  await AlertShow.init();
  await SessionState.initSession();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
