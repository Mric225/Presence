import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/common/theme_helper.dart';
import 'package:flutter_login_ui/pages/newocr.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'widgets/header_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:camera/camera.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  bool _scanning = false;

  TextEditingController _email = TextEditingController();
  TextEditingController _motdepasse = TextEditingController();
// -----------------------------------------------------------------------------
  void showlogin() => Fluttertoast.showToast(
        msg: 'Connexion réussie',
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );

// -----------------------------------------------------------------------------
  void showloginerror() => Fluttertoast.showToast(
        msg: 'Email ou mot de passe incorrect',
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );

// ---------------------------------------------------------------------------
  void showloginipv4() => Fluttertoast.showToast(
        msg: 'Vérifiez votre position',
        gravity: ToastGravity.BOTTOM,
        fontSize: 12.0,
        backgroundColor: Colors.grey[700],
        toastLength: Toast.LENGTH_SHORT,
      );
// -----------------------------------------------------------------------------
  Future login() async {
    final url = Uri.parse("https://www.geeksp3.com/pene/codingday/login.php");
    final ipv4 = await Ipify.ipv4();
    final response = await http.post(url, body: {
      "email": _email.text,
      "motdepasse": _motdepasse.text,
      "ipv4": ipv4,
    });

    var data = json.decode(response.body);
    if (data == "Success") {
      showlogin();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(
        '_email',
        _email.text,
      );

      await availableCameras().then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Newocr(
                      cameras: value,
                    )),
          ));
    } else if (data == "Error") {
      showloginerror();
      print('echec');
      print(ipv4);
    }
    if (data == "ipv4") {
      print("vérifiez votre position");
      showloginipv4();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
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
                              // ElevatedButton(
                              //   style: ButtonStyle(
                              //     backgroundColor:
                              //         MaterialStateProperty.all<Color>(
                              //             Colors.blue),
                              //   ),
                              //   child: Text(
                              //     'ip public.',
                              //     style: TextStyle(
                              //         color: Colors.white, fontSize: 16),
                              //   ),
                              //   onPressed: () async {
                              //     final ipv4 = await Ipify.ipv4();

                              //     print(ipv4);
                              //   },
                              // ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
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
