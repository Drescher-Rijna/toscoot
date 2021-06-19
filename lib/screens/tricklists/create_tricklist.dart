import 'package:flutter/material.dart';
import 'package:toscoot/services/database.dart';

class Create_TrickList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TrickListForm(),
    );
  }
}


// TrickListForm
class TrickListForm extends StatefulWidget {
  @override
  _TrickListFormState createState() => _TrickListFormState();
}

class _TrickListFormState extends State<TrickListForm> {
  
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController;

  static List<String> tricksList = [null];

  //field states
  String Listtitle = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Create A Tricklist'),
          centerTitle: true,
          backgroundColor: Colors.orange[900],
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
                    //_formKey.currentState.save();
                    await DatabaseService().updateTrickListData(Listtitle, tricksList);
                }
              },
            ),
          ],
        ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title textfield
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.grey[100], fontSize: 20.0),
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey[500]),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[700], width: 2.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange[900], width: 2.0),
                      ),
                    ),
                    onChanged: (val) {
                    setState(() => Listtitle = val);
                    },
                    validator: (v){
                      if(v.trim().isEmpty) return 'Please enter something';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 40,),
                Text(
                  'Add Tricks', 
                  style: TextStyle(
                    fontWeight: FontWeight.w700, 
                    fontSize: 18, 
                    color: Colors.grey[100]
                  ),
                ),
                ..._getTricks(),
              ],
            ),
          ),
        ),
        
      ),
    );
  }

  /// get tricks text-fields
  List<Widget> _getTricks(){
    List<Widget> tricksTextFields = [];
    for(int i=0; i<tricksList.length; i++){
      tricksTextFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(child: TrickTextFields(i)),
              SizedBox(width: 16,),
              // we need add button at last friends row
              _addRemoveButton(i == tricksList.length-1, i),
            ],
          ),
        )
      );
    }
    return tricksTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          tricksList.insert(tricksList.length, null);
        }
        else tricksList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.greenAccent[400] : Colors.redAccent[400],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }


}


// TrickTextField
class TrickTextFields extends StatefulWidget {

  final int index;

  TrickTextFields(this.index);

  @override
  _TrickTextFieldsState createState() => _TrickTextFieldsState();
}

class _TrickTextFieldsState extends State<TrickTextFields> {
  TextEditingController _nameController;
  
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _TrickListFormState.tricksList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (val) => _TrickListFormState.tricksList[widget.index] = val,
      style: TextStyle(color: Colors.grey[100], fontSize: 16.0),
      decoration: InputDecoration(
        hintText: 'Trick name',
        hintStyle: TextStyle( 
          fontSize: 16, 
          color: Colors.grey[500]
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700], width: 2.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange[900], width: 2.0),
        ),
      ),
      validator: (val){
        if(val.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}





