import 'dart:convert';

import 'package:ffp_dealer_distribution/pages/benhistory.dart';
import 'package:flutter/material.dart';
import 'package:ffp_dealer_distribution/services/beneficiary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/httpservice.dart';
import 'home.dart';

class BenList extends StatefulWidget {
  int id;
  String path;
  BenList({Key? key, required this.id, required this.path}) : super(key: key);

  @override
  State<BenList> createState() => _BenListState();
}

class _BenListState extends State<BenList> {
  var isCheck = false;
  List<Beneficiary> benList = <Beneficiary>[];

  Future<List<Beneficiary>> BeneficiaryData() async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String getData = await prefs.getString('BenList')?? '';
      var jsonD = jsonDecode(getData) as List;
      List<Beneficiary> beneficiaryList = <Beneficiary>[];

      int length = jsonD.length;

      for(int i=0; i<length; i++){
        Beneficiary benificiary = Beneficiary(int.parse(jsonD[i]['id'].toString()), jsonD[i]['name'], int.parse(jsonD[i]['unionId'].toString()), jsonD[i]['unionName'], jsonD[i]['nId'], jsonD[i]['sNId'], int.parse(jsonD[i]['dealerId'].toString()), jsonD[i]['dealerName'], int.parse(jsonD[i]['cardNo'].toString()), jsonD[i]['mobNo'], jsonD[i]['image']);
        beneficiaryList.add(benificiary);
      }

      beneficiaryList.sort((a, b) => a.cardNo!.compareTo(b.cardNo?.toInt() ?? 0));

      if(widget.path.contains('benId')){
        beneficiaryList.forEach((beneficiary) {
          if (beneficiary.id == widget.id){
            benList.add(beneficiary);
          }
        });

        setState(() {
          isCheck = true;
        });
      }

      else{
        setState(() {
          benList.addAll(beneficiaryList);
          isCheck = true;
        });
      }
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

  @override
  void initState() {
    super.initState();
    BeneficiaryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ভোক্তার তালিকা'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: isCheck == true?
      Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListView.builder(
            itemCount: benList.length,
            itemBuilder: (BuildContext context, int index) {
              return cardWidget(benList[index]);
            }),
      ): Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget cardWidget(Beneficiary ben) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(color: Colors.green, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(base64Decode('${ben.image}'),
                      width: 70,
                      height: 90,
                      ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('নামঃ ${ben.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      Text('কার্ড নম্বরঃ ${ben.cardNo}'),
                      Text('ইউনিয়নঃ ${ben.unionName}'),
                      Text('মোবাইল নম্বরঃ ${ben.mobNo}'),
                      Text('ডিলারের নামঃ ${ben.dealerName}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => BenHistory(beneficiary: ben,)),
                          ),
                        );
                      },
                      child: Text('চাল বিতরনের জন্য ক্লিক করুন'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[800],
                      ),
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
