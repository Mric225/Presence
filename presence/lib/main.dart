import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/pages/login_page.dart';
import 'package:flutter_login_ui/pages/profile_page.dart';
import 'package:hexcolor/hexcolor.dart';




 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

 
  Color _primaryColor = HexColor('#34495E');
  Color _accentColor = HexColor('#34495E');
  runApp(MaterialApp(
      home:  LoginPage(),
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Login UI',
      theme: ThemeData(
        primaryColor: _primaryColor,
        scaffoldBackgroundColor: Colors.grey.shade100, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _accentColor),
        // primarySwatch: Colors.grey,
      ),
      
    ));
}