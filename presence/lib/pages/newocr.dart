import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/profile_page.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:network_info_plus/network_info_plus.dart';
// import 'package:geolocator/geolocator.dart';

final info = NetworkInfo();



class Newocr extends StatefulWidget {
  final String? image;
  const Newocr({key, this.image}) : super(key: key);

  String get imagePath => image.toString();

  @override
  _NewocrState createState() => _NewocrState();
}

class _NewocrState extends State<Newocr> {
  String textOcr = "";
  String imagePath = "";
  String wifiName = "";
   String _email = "";

  final _formKey = GlobalKey<FormState>();
  TextEditingController _id = TextEditingController();

  Widget _buildnom() {
    return new TextFormField(
      controller: _id,
      decoration: new InputDecoration(
        labelText: ' Veuillez saisir un titre',
        border: new OutlineInputBorder(),
      ),
      maxLength: 25,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '  Veuillez saisir un titre';
        }
        return null;
      },
    );
  }
// -----------------------------------------
  Future getEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
     setState(() {
       _email = preferences.getString('_email')!;
     });
  }

  @override
  void initState() {
    super.initState();
    getEmail();
  }



// -----------------------------------------------------------------------------
  Future getData() async {
    var url = 'http://172.16.21.228/image2text/out.php';
    http.Response response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    // print(data);
    textOcr = data.toString();
  }

// -----------------------------------------------------------------------------
  Future enreg() async {
    final url = Uri.parse("https://192.168.137.184/codingday/save.php");

    var request = http.MultipartRequest('POST', url);

    request.fields['email'] = _email;
    // request.fields['textOcr'] = textOcr;
    request.fields['datecreation'] = DateTime.now().toString();

    // String? imgPath = widget.image;

    // var pic = await http.MultipartFile.fromPath("image", imgPath!);
    // request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Enregistré !");
    } else {
      print("Non enregistré");
    }
  }



  // -----------------------



    Future dep() async {
    final url = Uri.parse("https://192.168.137.184/codingday/dep.php");

    var request = http.MultipartRequest('POST', url);

    request.fields['email'] = _email;
    // request.fields['textOcr'] = textOcr;
    request.fields['datedep'] = DateTime.now().toString();

    // String? imgPath = widget.image;

    // var pic = await http.MultipartFile.fromPath("image", imgPath!);
    // request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print("Enregistré !");
    } else {
      print("Non enregistré");
    }
  }

  // ---------------------------------------------------------------------------
  void showsave() => Fluttertoast.showToast(
        msg: 'Enregistré !',
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );

  // ---------------------------------------------------------------------------



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          backgroundColor: const Color(0xFF34495E),
          title: Text('Validé !'),
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(height: 25),
                    ButtonBar(
                      children: <Widget>[
                        
                        Center(child: _email == '' ? Text('') : Text(_email)),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          child: Text(
                            'Emarger',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              enreg();

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Enregistré !",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          )),
                                      // content: Text("Enregistré !"),
                                      actions: <Widget>[
                                        new TextButton(
                                          child: new Text("Close"),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ProfilePage(),
                                              ),
                                              (route) => false,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              // showsave();
                            }
                          },
                          
                        ),
                      ],
                      alignment: MainAxisAlignment.center,
                    ),
                    ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.green),
                          ),
                          child: Text(
                            'DEPART.',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                             
                              dep();
                              
                                showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Enregistré !", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green,)),
                                  // content: Text("Enregistré !"),
                                  actions: <Widget>[
            
                              new TextButton(
                                child: new Text("Close"),
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                   builder: (BuildContext context) =>
                                    ProfilePage(),
                              ),
                              (route) => false,
                            );
                                },
                              ),
                            ],
                                );
                                });
                              // showsave();
                            }
                          },
                        ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
