import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/newocr.dart';
import 'profile_page.dart';
import 'widgets/header_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:network_info_plus/network_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  // Key _formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  bool _scanning = false;
  String imagePath = "";
  final ImagePicker _picker = ImagePicker();
  // final String? wifiGateway = "";

  TextEditingController _email = TextEditingController();
  TextEditingController _motdepasse = TextEditingController();

// -----------------------------------------------------------------------------
  void login() async {
    // final url = Uri.parse("http://www.geeksp3.com/pene/codingday/login.php");
    final url = Uri.parse("http://192.168.137.184/codingday/login.php");
    var wifiGateway = await info.getWifiGatewayIP();

    final response = await http.post(url, body: {
      "email": _email.text,
      "motdepasse": _motdepasse.text,
      "wifiGateway": wifiGateway.toString(),
    });

    if (response.statusCode == 200) {
      var datas = jsonDecode(response.body);

      var resultat = datas['data'];
      String message = resultat[0];
      int success = resultat[1];
      // String nom = resultat[2]['nom'];
      // var idClient = resultat[2]['id'];

      // print(data);
      // print('success = $success');
      // print(idClient);
      // print(resultat[2]['nom']);
      // print(resultat[2]['prenom']);
      // print(resultat[2]['email']);
      // print(resultat[2]['motdepasse']);
      // print(resultat[2]['datepub']);

      if (message == "Success") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('_email', _email.text,);
        print(wifiGateway);
        print(message);
        // print(nom);
        if (success == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Newocr()),
          );
        }
        if (success == 1) {
          print(message);
        }
      } else {
        print("echec");
      }
    } else {
      print("Email ou Mot de passe incorrecte");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            imagePath != ""
                ? Container(
                    height: 210,
                    width: 210,
                    child: Image.file(
                        File(imagePath)), //let's create a common header widget
                  )
                : Container(
                    height: _headerHeight,
                    child: HeaderWidget(
                        _headerHeight,
                        true,
                        Icons
                            .login_rounded), //let's create a common header widget
                  ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Connectez-vous à votre session',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: _email,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Adresse email',
                                      'Entrez votre adresse email'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez saisir votre adresse email';
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  controller: _motdepasse,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Mot de passe',
                                      'Entrez votre mot de passe'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez saisir votre mot de passe';
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 25.0),
                              _scanning
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blueGrey),
                                    ))
                                  : Icon(
                                      Icons.done,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                              SizedBox(height: 10.0),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueGrey),
                                ),
                                onPressed: () async {
                                  final XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    File? croppedFile =
                                        await ImageCropper.cropImage(
                                      sourcePath: image.path,
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.square,
                                        CropAspectRatioPreset.ratio3x2,
                                        CropAspectRatioPreset.original,
                                        CropAspectRatioPreset.ratio4x3,
                                        CropAspectRatioPreset.ratio16x9
                                      ],
                                      androidUiSettings: AndroidUiSettings(
                                        toolbarTitle: "Rogner l'image",
                                        toolbarColor: const Color(0xFF34495E),
                                        toolbarWidgetColor: Colors.white,
                                        activeControlsWidgetColor: Colors.red,
                                        initAspectRatio:
                                            CropAspectRatioPreset.original,
                                        lockAspectRatio: false,
                                      ),
                                      iosUiSettings: IOSUiSettings(
                                        minimumAspectRatio: 1.0,
                                      ),
                                    );
                                    if (croppedFile != null) {
                                      setState(() {
                                        imagePath = croppedFile.path;
                                      });
                                    }
                                  }
                                },
                                child: Text("Ouvrir la camera"),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                child: Text(
                                  'wifi.',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                onPressed: () async {
                                  var wifiGateway =
                                      await info.getWifiGatewayIP();

                                  print(wifiGateway);
                                },
                              ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                //  SizedBox(height: 25),

                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'se connecter'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _scanning = true;
                                      });
                                      login();
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
