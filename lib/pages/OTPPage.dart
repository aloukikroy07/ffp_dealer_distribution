import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ffp_dealer_distribution/services/beneficiary.dart';
import 'package:ffp_dealer_distribution/services/httpservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/httpservice.dart';

class OTP extends StatefulWidget {
  final Beneficiary beneficiary;
  const OTP({Key? key, required this.beneficiary}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController otpController = TextEditingController();
  bool countDownComplete = false;
  final formKey = GlobalKey<FormState>();
  int? otp;
  String? msg;

  startTimeout() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timer.tick >= 300) {
          setState(() {
            countDownComplete = true;
          });
          timer.cancel();
        }
      });
    });
  }

  Future<void> sendOTP() async{
    String otpMessage = await HttpService().sendOTP('${widget.beneficiary.mobNo}');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? otpCode = await prefs.getInt('OTP');
    print(otpCode);
    setState(() {
      otp = otpCode;
      msg = otpMessage;
    });
  }

    @override
    initState() {
      super.initState();
      startTimeout();
      sendOTP();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("ওটিপি"),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Text('ভোক্তার মোবাইল নম্বর ${widget.beneficiary
                    .mobNo} এ ওটিপি এর মেসেজ পাঠানো হয়েছে। মেসেজ এ পাঠানো ওটিপি নম্বরটি নিচের ঘরে বসান। মেসেজ না গেলে মেসেজ এর জন্য ৫ মিনিট অপেক্ষা করুন এবং পুনরায় মেসেজ পাঠান বাটনে ক্লিক করুন।'),
                SizedBox(height: 20,),
                TextFormField(
                  controller: otpController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ওটিপি',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'ওটিপি বসান';
                    return null;
                  },
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if(int.parse(otpController.text) == otp){
                          print('Success');
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return WillPopScope(
                                  onWillPop: () {return Future.value(false);},
                                  child: AlertDialog(
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.check_circle,
                                          color: Colors.green[800],
                                          ),
                                        ],
                                      ),
                                      content: Text('সফলভাবে বর্তমান মাসের ৩০ কেজি চাল বিতরন করা হয়েছে।',
                                                    style: TextStyle(color: Colors.green,)),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                ..pop()
                                                ..pop()
                                                ..pop()
                                                ..pop();
                                            },
                                            child: Text('ওকে')),
                                      ],
                                    )
                                );
                              }
                          );
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text('ওটিপি কোড মিলে নাই। সঠিক ওটিপি বসিয়ে চেষ্টা করুন।'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('ওকে'))
                              ],
                            ),
                          );
                        }
                      }
                    },
                    child: Text('সাবমিট'),

                  ),
                ),

                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: ElevatedButton(
                    onPressed: countDownComplete? (){
                      Navigator.pushReplacementNamed(context, '/otppage');
                    }: null,
                    child: Text('পুনরায় মেসেজ পাঠান'),

                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Future<bool> _onBackPressed() async{
      Navigator.of(context)
        ..pop()
        ..pop()
        ..pop()
        ..pop();
      return true;
    }
  }
