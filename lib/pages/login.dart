import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ffp_dealer_distribution/pages/home.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureTex = true;

  String username = 'a';
  String password = 'a';
  final formKey = GlobalKey<FormState>();

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    'images/dgfood_logo.png',
                    width: 200.0,
                    height: 200.0,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'খাদ্যবান্ধব কর্মসুচী',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'ইউসারনেম দিন';
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      obscureText: obscureTex,
                      obscuringCharacter: "*",
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureTex = !obscureTex;
                            });
                          },
                          // icon validation true false
                        icon: Icon(obscureTex ? Icons.visibility_off : Icons.visibility))
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'পাসওয়ার্ড দিন';
                        return null;
                      },
                    ),
                  ),
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green[800],
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              if(nameController.text == username && passwordController.text == password){
                                Navigator.pushReplacementNamed(
                                  context, '/home'
                                );
                              }
                              else{
                                print('Wrong credentials');
                                final snackBar = SnackBar(
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 10),
                                  content: const Text('ইউসারনেম অথবা পাসওয়ার্ড ভুল। পুনরায় সঠিকভাবে দিয়ে চেষ্টা করুন।'),
                                  action: SnackBarAction(
                                    label: 'Close',
                                    onPressed: () {
                                      // Some code to undo the change.
                                    },
                                  ),
                                );

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            });
                          }
                        },
                      )
                  ),
                  TextButton(
                    onPressed: () {

                    },
                    child: const Text('Forgot Password',),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('ইন্টারনেট সংযোগ নেই।'),
      content: const Text('দয়া করে আপনার ইন্টারনেট সংযোগ চেক করুন।'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
