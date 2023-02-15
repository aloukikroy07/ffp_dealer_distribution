import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart';
import 'beneficiary.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService{
  final String token = "FFP@DGFOOD#BCL&0088";

  Future<List<Beneficiary>> getBenById (int benId) async {
    List<Beneficiary> benList=[];
    Beneficiary ben;
    String url = 'https://202.84.36.139/FFPAPI/api/mobile/benId';
    Map data = {
      'token': token,
      'id': benId
    };
    var body = jsonEncode(data);

    Response response = await post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);

    var code = jsonDecode(response.body)['code'];
    if(response.statusCode == 200){
      if(code==200) {
        String source = Utf8Decoder().convert(response.bodyBytes);
        Map<String, dynamic> jsonD = jsonDecode(source)['ben'][0];
        print(jsonD);
        ben = Beneficiary(int.parse(jsonD['id'].toString()), jsonD['ecBeneficiaryName'], int.parse(jsonD['unionId'].toString()), jsonD['unionName'], jsonD['nationalID'], jsonD['secondNationalID'], int.parse(jsonD['dealerId'].toString()), jsonD['dealerName'], int.parse(jsonD['cardNo'].toString()), jsonD['givenMobileNo'], jsonD['image']);
        benList.add(ben);
        return benList;
      }
      else{
        return benList;
      }
    }

    else{
      return benList;
    }
  }

  Future<List<Beneficiary>> getBenListByDealerId (int dealerId) async {
    List<Beneficiary> benList=[];
    try{
      String url = 'https://202.84.36.139/FFPAPI/api/mobile/dealerId';
      Map data = {
        'token': token,
        'id': dealerId
      };
      var body = jsonEncode(data);

      Response response = await post(Uri.parse(url), headers: {"Content-Type": "application/json"}, body: body);

      var code = jsonDecode(response.body)['code'];
      if(response.statusCode == 200){
        if(code==200) {
          String source = Utf8Decoder().convert(response.bodyBytes);
          var jsonD = jsonDecode(source)['ben'] as List;
          //benList = List<Beneficiary>.from(jsonD.map((x)=> Beneficiary.fromJson(x)).toList());
          int length = jsonD.length;
          print(length);

          for(int i=0; i<length; i++){
            Beneficiary benificiary = Beneficiary(int.parse(jsonD[i]['id'].toString()), jsonD[i]['ecBeneficiaryName'], int.parse(jsonD[i]['unionId'].toString()), jsonD[i]['unionName'], jsonD[i]['nationalID'], jsonD[i]['secondNationalID'], int.parse(jsonD[i]['dealerId'].toString()), jsonD[i]['dealerName'], int.parse(jsonD[i]['cardNo'].toString()), jsonD[i]['givenMobileNo'], jsonD[i]['image']);
            benList.add(benificiary);
          }
          benList.sort((a, b) => a.cardNo!.compareTo(b.cardNo?.toInt() ?? 0));
          return benList;
        }
        else{
          return benList;
        }
      }

      else{
        return benList;
      }
    }
    catch(Exception){
      return benList;
    }

  }

  Future<String> sendOTP (String mobNo) async {
    try {
      var rng = new Random();
      int code = rng.nextInt(9999) + 1000;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('OTP');
      await prefs.setInt('OTP', code);

      String url = 'http://bulksms1.teletalk.com.bd:8091/link_sms_send.php?mobile=$mobNo&op=SMS&user=dgfood2&pass=DgFdJ7H6T9Pq&sms=USE+$code+AS+OTP+FOR+FFP+BENEFICIARY+DISTRIBUTION-DGFOOD&charset=UTF-8&a_key=c723dc15bd7eb3cb26a4f4dfc9ec7253&p_key=1971&cid=PE5YMFULAD';

      Response response = await get(Uri.parse(url));

      String resBody = response.body;

      return resBody.substring(7, 15);
    }
    catch(Exception){
      return 'Failed';
    }

  }
}


