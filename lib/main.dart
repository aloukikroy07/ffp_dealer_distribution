import 'dart:io';

import 'package:ffp_dealer_distribution/pages/OTPPage.dart';
import 'package:ffp_dealer_distribution/pages/benhistory.dart';
import 'package:ffp_dealer_distribution/pages/home.dart';
import 'package:ffp_dealer_distribution/pages/login.dart';
import 'package:ffp_dealer_distribution/pages/benlist.dart';
import 'package:ffp_dealer_distribution/services/beneficiary.dart';
import 'package:flutter/material.dart';

void main() {
  Beneficiary beneficiary = Beneficiary(null, '', null, '', '', '', null, '', null, '', '');
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => LogIn(),
      '/home': (context) => Home(),
      '/benlist': (context) => BenList(id: 0, path: '',),
      '/benhistory': (context) => BenHistory(beneficiary: beneficiary),
      '/otppage': (context) => OTP(beneficiary: beneficiary),
    },
  ));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}