import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'newocr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  bool _scanning = false;
  String imagePath = "";
  final ImagePicker _picker = ImagePicker();
  String _email = "";
// -----------------------------------------

 
// -----------------------------------------------------------------------------
  Future<void> ocr() async {
    var postUri = Uri.parse('http://172.16.21.228/image2text/upload.php');

    http.MultipartRequest request = new http.MultipartRequest("POST", postUri);

    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('imagePath', imagePath);

    request.files.add(multipartFile);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('Traité !');

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Newocr(
                  // textocr: textocr,
                  image: imagePath,
                )),
      );
    } else {
      print('Echec !');
    }
  }

  // ---------------------------------------------------------------------------
  void showToast() => Fluttertoast.showToast(
        msg: 'Veuillez choisir une image',
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );
// -----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[250],
      appBar: AppBar(
        title: Text(
          "SELECTIONNEZ VOTRE FABRIQUE",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ])),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                new Container(
                    child: new IconButton(
                        //    icon: new Icon(Icons.bookmark),
                        //    onPressed: () { /* Your code */ },
                        //  ),

                        icon: new Icon(Icons.logout),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(
                                builder: (context) => LoginPage()),
                            (_) => false,
                          );
                        }))
              ],
            ),
          )
        ],
      ),
     

      // --------------------------------------------------------------------------------------------------
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              width: double.infinity,
            ),
            SizedBox(height: 20),

            SizedBox(height: 25),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueGrey),
              ),
              onPressed: () async {
                Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
              },
              child: Text("FABRIQUE AUF"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
                },
                child: Text('FABRIQUE MTN ACADEMY')),
            // Center(child: _email == '' ? Text('') : Text(_email)),
          ],
        ),
      ),
    );
  }
}
