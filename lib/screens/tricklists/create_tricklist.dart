import 'package:flutter/material.dart';
import 'package:toscoot/screens/tricklists/tricklists.dart';
import 'package:toscoot/services/database.dart';
import 'package:toscoot/shared/loading.dart';

// TrickListForm
class TrickListForm extends StatefulWidget {
  @override
  _TrickListFormState createState() => _TrickListFormState();
}

class _TrickListFormState extends State<TrickListForm> {
  
  final _formKey = GlobalKey<FormState>();

  List<String> tricksList = [];
  String _currentTrick = '';


  //field states
  String listtitle = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Color(0xfff2f2f2),
        appBar: AppBar(
          title: Text('Create A Tricklist'),
          centerTitle: true,
          backgroundColor: Color(0xffad0000),
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
              onPressed: () async {
                if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;                      
                    });
                    await DatabaseService().updateTrickListData(listtitle, tricksList);
                    Navigator.pop(context, MaterialPageRoute(builder: (context) => TrickLists()));
                }
              },
            ),
          ],
        ),
      body: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column( 
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title', 
                      hintStyle: TextStyle(fontSize: 16.0),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffad0000), width: 2.0),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                    validator: (val) => val.isEmpty ? 'Enter a title' : null,
                      onChanged: (val) {
                        setState(() => listtitle = val);
                      },
                  ),
                  SizedBox(height: 30,),
                  Text(
                    'Add new trick',
                    style: TextStyle(
                      color: Color(0xff1a1a1a),
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Trick', 
                      hintStyle: TextStyle(fontSize: 16.0),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffad0000), width: 2.0),
                      ),
                    ),
                    style: TextStyle(fontSize: 16),
                    validator: (val) => val.isEmpty ? 'Enter a trick' : null,
                      onChanged: (val) {
                        setState(() => _currentTrick = val);
                      },
                    ),
                  ],
                ),
              ),
          SizedBox(height: 20.0,),
          TextButton.icon(
            icon: Icon(
              Icons.add,
              color: Colors.grey[100],
            ),
            style: TextButton.styleFrom(
              backgroundColor: Color(0xffad0000),
              padding: EdgeInsets.all(12.0),
            ),
            onPressed: () async {
              if(_formKey.currentState.validate()){
                setState(() => tricksList.add(_currentTrick));
              }
            },
            label: Text(
              'Add new trick',
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 16.0
              ),
            ),
          ),                              
          SizedBox(height: 30.0,),
          Expanded(child: getTricks(tricksList)),
        ],
      ),
            ),
        );
  }


Widget getTricks(List tricklist) {
  return ListView.builder(
    itemCount: tricklist.length,
    itemBuilder: (context, index) {
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
                  tricklist[index],
                  style: TextStyle(
                    color: Color(0xff1a1a1a),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      tricksList.remove(tricksList[index]);            
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Color(0xff1a1a1a),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  );
}


}