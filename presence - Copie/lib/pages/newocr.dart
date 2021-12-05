import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';

class Newocr extends StatefulWidget {
  final String? image;
  final List<CameraDescription>? cameras;
  const Newocr({key, this.image, this.cameras}) : super(key: key);

  @override
  _NewocrState createState() => _NewocrState();
}

class _NewocrState extends State<Newocr> {
  String? imagePath = "";
  String _email = "";

  late bool enableAudio;

  late CameraController controller;
  XFile? pictureFile;

// -----------------------------------------
  Future getEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _email = preferences.getString('_email')!;
    });
  }

// -----------------------------------------------------------------------
  void showechecdep() => Fluttertoast.showToast(
        msg: 'Désolé, vous avez déjà émargé',
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );
// ----------------------------------------------------------------------------
  void showconn() => Fluttertoast.showToast(
        msg: 'Echec de connexionj',
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );

// -----------------------------------------------------------------------------------------------------------

  void takepic() async {
    pictureFile = await controller.takePicture();
    setState(() {});

    if (pictureFile != null)
      Image.network(
        pictureFile!.path,
        height: 200,
      );
    final url = Uri.parse("https://www.geeksp3.com/pene/codingday/save.php");

    var request = http.MultipartRequest('POST', url);

    request.fields['email'] = _email;
    request.fields['datecreation'] =
        DateFormat("yyyy-MM-dd").format(DateTime.now());
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('hh:mm:ss').format(now);
    request.fields['heurearrive'] = formattedDate;

    var pic = await http.MultipartFile.fromPath(
      "imagePath",
      pictureFile!.path,
    );
    request.files.add(pic);

    var response = await request.send();
    var resultatResponse = await http.Response.fromStream(response);
    final resultatData = json.decode(resultatResponse.body);

    if (response.statusCode == 200) {
      if (resultatData == "reussi") {
        // if (data == "reussi") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Enregistré !",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    )),
                actions: <Widget>[
                  new TextButton(
                      child: new Text("Fermer"),
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.clear();

                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(builder: (context) => LoginPage()),
                          (_) => false,
                        );
                      }),
                ],
              );
            });
      } else {
        showechecdep();
      }
    } else {
      showconn();
    }

    @override
    void initState() {
      super.initState();
      getEmail();
      controller = new CameraController(
        widget.cameras![1],
        ResolutionPreset.max,
        enableAudio: enableAudio = false,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }

    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }

    // ---------------------------------------------------------------------------

// -----------------------------------------------------------------------------

    // -----------------------------------------------------------------------------
    Future dep() async {
      final url = Uri.parse("https://www.geeksp3.com/pene/codingday/dep.php");
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('hh:mm:ss').format(now);

      final response = await http.post(url, body: {
        "email": _email,
        "datedep": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "heuredep": formattedDate,
      });

      var data = json.decode(response.body);

      if (data == "depsave") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Enregistré !",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    )),
                actions: <Widget>[
                  new TextButton(
                      child: new Text("Fermer"),
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.clear();

                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(builder: (context) => LoginPage()),
                          (_) => false,
                        );
                      }),
                ],
              );
            });
      } else {
        showechecdep();
      }
    }

    // ---------------------------------------------------------------------------
    // void showsave() => Fluttertoast.showToast(
    //       msg: 'Enregistré !',
    //       gravity: ToastGravity.BOTTOM,
    //       fontSize: 12.0,
    //       backgroundColor: Colors.grey[700],
    //       toastLength: Toast.LENGTH_SHORT,
    //     );

    // ---------------------------------------------------------------------------

    @override
    Widget build(BuildContext context) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;

      if (!controller.value.isInitialized) {
        return const SizedBox(
            child: Center(
          child: CircularProgressIndicator(),
        ));
      }

      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "MARQUEZ MA PRESENCE",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            automaticallyImplyLeading: false,
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
                  top: 5,
                  right: 10,
                ),
                child: Stack(
                  children: <Widget>[
                    new Container(
                        child: new IconButton(
                            icon: new Icon(Icons.logout),
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.clear();

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
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Form(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: width * 0.75,
                        height: height * 0.55,
                        margin: EdgeInsets.all(1),
                        padding: EdgeInsets.all(2),
                        child: CameraPreview(controller),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue,
                              // width: 5,
                            )),
                      ),
                      SizedBox(height: 55),
                      ButtonBar(
                        children: <Widget>[
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            child: Text(
                              'EMARGER',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () async {
                              takepic();
                            },
                          ),
                          SizedBox(width: 70),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            child: Text(
                              'DEPART',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              dep();
                            },
                          ),
                        ],
                        alignment: MainAxisAlignment.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
