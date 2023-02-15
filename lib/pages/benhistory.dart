import 'dart:convert';

import 'package:ffp_dealer_distribution/pages/OTPPage.dart';
import 'package:flutter/material.dart';
import 'package:ffp_dealer_distribution/services/beneficiary.dart';

import '../services/httpservice.dart';

class BenHistory extends StatefulWidget {
  final Beneficiary beneficiary;
  const BenHistory({Key? key, required this.beneficiary}) : super(key: key);

  @override
  State<BenHistory> createState() => _BenHistoryState();
}

class _BenHistoryState extends State<BenHistory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ভোক্তার তথ্য'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              //title: Text('ফলাফল'),
              content: Text('ভোক্তার মোবাইল নম্বরে ওটিপি এর মেসেজ যাবে এবং চাল বিতরনের জন্য সেই ওটিপি বসাতে হবে। ভোক্তার মোবাইল নম্বর সাথে আছে কিনা চেক করে দেখুন। এছাড়া সঠিক ভোক্তাকে বিতরন করছেন কিনা চেক করে দেখুন কারন একবার চাল বিতরন করলে সেটা পরিবর্তনের সুযোগ নেই।',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ফেরত যান')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => OTP(beneficiary: widget.beneficiary,)),
                        ),
                      );
                    },
                    child: Text('ওটিপি পাঠান'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[800],
                    ),
                ),
              ],
            ),
          );
        },
        label: const Text('চাল বিতরনের জন্য ক্লিক করুন'),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: const BorderSide(color: Colors.green, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(base64Decode('${widget.beneficiary.image}'),
                          width: 100,
                          height: 120,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('নামঃ ${widget.beneficiary.name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('কার্ড নম্বরঃ ${widget.beneficiary.cardNo}'),
                          Text('ইউনিয়নঃ ${widget.beneficiary.unionName}'),
                          Text('মোবাইল নম্বরঃ ${widget.beneficiary.mobNo}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20,),

            Text('ভোক্তার পূর্ববর্তী চাল গ্রহনের তথ্য',
              style: TextStyle(
                fontSize: 20,
                color: Colors.cyan[800],
              ),
            ),

            Container(
              height: 380,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
              ),
              child: Column(
                children: [
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(3)
                    },
                    border: TableBorder.all(
                      color: Colors.cyan,
                      style: BorderStyle.solid,
                      width: 2
                    ),
                    children: [
                      TableRow( children: [
                        Column(children:[Text('তারিখ', style: TextStyle(fontSize: 15.0))]),
                        Column(children:[Text('পরিমান (কেজি)', style: TextStyle(fontSize: 15.0))]),
                        Column(children:[Text('ডিলারের নাম', style: TextStyle(fontSize: 15.0))]),
                      ]),
                    ]
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return distListView();
                      }),
                ],
              ),
            ),
          ]
        )
      )
    );
  }

  Widget distListView(){
    return Table(
        columnWidths: {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(3)
        },
        border: TableBorder.all(
            color: Colors.cyan,
            style: BorderStyle.solid,
            width: 2
        ),
        children: [
          TableRow( children: [
            Column(children:[Text('৩০/০১/২০২২', style: TextStyle(fontSize: 15.0))]),
            Column(children:[Text('২০', style: TextStyle(fontSize: 15.0))]),
            Column(children:[Text('মিস্টার এবিসি', style: TextStyle(fontSize: 15.0))]),
          ]),
        ]
    );
  }
}

