import 'dart:convert';
import 'dart:ui';
import 'package:ffp_dealer_distribution/pages/benlist.dart';
import 'package:ffp_dealer_distribution/services/beneficiary.dart';
import 'package:flutter/material.dart';
import 'package:ffp_dealer_distribution/pages/NavBar.dart';
import 'package:ffp_dealer_distribution/services/httpservice.dart';
import 'package:ffp_dealer_distribution/services/beneficiary.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _scanBarcode = 'Unknown';

  var isCheck = false;
  List<Beneficiary> benList = <Beneficiary>[];

  Future<List<Beneficiary>> BeneficiaryData() async {
    try{
      benList = await HttpService().getBenListByDealerId(1556);
      setState(() {
        isCheck = true;
      });
      return benList;
    }

    catch(Exception){
      print("error = $Exception");
      setState(() {
        benList = [];
        isCheck = true;
      });
      return benList;
    }
    return [];
  }

  setValues() async{
    await BeneficiaryData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('BenList');
    await prefs.setString('BenList', jsonEncode(benList));
  }

  @override
  void initState() {
    super.initState();
    setValues();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('হোম'),
        //automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        width:  MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('images/BG_Home.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            BackdropFilter(filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.fromSize(
                  size: Size(150, 110),
                  child: ClipRRect(
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.green,
                        onTap: () async {
                          if(isCheck == false){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text('তথ্য লোড হচ্ছে। ১ মিনিট পর QR কোড স্ক্যান করুন।'),
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

                          else{
                            await scanQR();
                            //_scanBarcode = 'https://ffp.dgfood.gov.bd/foodfriendly/qrview/2231736';
                            print(_scanBarcode);
                            if(_scanBarcode.startsWith('https://ffp.dgfood.gov.bd/foodfriendly/qrview/')){
                              int benId = int.parse(_scanBarcode.substring(46));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => BenList(id: benId, path: 'benId',)),
                                ),
                              );
                            }

                            else if(_scanBarcode == '-1'){

                            }

                            else{
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('ফলাফল'),
                                  content: Text('ভুল QR কোড স্ক্যান করা হয়েছে।'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('ক্লিক করুন'))
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.qr_code,
                              size: 80,
                              color: Colors.black,
                            ), // <-- Icon
                            Text("QR কোড স্ক্যান",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                shadows: <Shadow>[Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )],
                              ),
                            ), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40,),
                SizedBox.fromSize(
                  size: Size(150, 110),
                  child: ClipRRect(
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.green,
                        onTap: () async {
                          if(isCheck == false){
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text('তথ্য লোড হচ্ছে। ১ মিনিট পর ক্লিক করুন।'),
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
                          else{
                            int dealerId= 1556;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => BenList(id: dealerId, path: 'dealerId',)),
                              ),
                            );
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.list_alt_sharp,
                              size: 80,
                              color: Colors.black,
                            ), // <-- Icon
                            Text("ভোক্তার তালিকা",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                shadows: <Shadow>[Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )],
                              ),
                            ), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 50,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.fromSize(
                  size: Size(150, 110),
                  child: ClipRRect(
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.green,
                        onTap: () async {

                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.pie_chart,
                              size: 80,
                              color: Colors.black,
                            ), // <-- Icon
                            Text("বিতরনের প্রতিবেদন",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                shadows: <Shadow>[Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )],
                              ),
                            ), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40,),
                SizedBox.fromSize(
                  size: Size(150, 110),
                  child: ClipRRect(
                    child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.green,
                        onTap: () async {
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.insert_chart,
                              size: 80,
                              color: Colors.black,
                            ), // <-- Icon
                            Text("সংক্ষিপ্ত প্রতিবেদন",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                shadows: <Shadow>[Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                )],
                              ),
                            ), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
}
