import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart';

class Beneficiary{
  int? id;
  String? name;
  int? unionId;
  String? unionName;
  String? nId;
  String? sNId;
  int? dealerId;
  String? dealerName;
  int? cardNo;
  String? mobNo;
  String? image;

  Beneficiary(this.id, this.name, this.unionId, this.unionName, this.nId, this.sNId,
      this.dealerId, this.dealerName, this.cardNo, this.mobNo, this.image);

  factory Beneficiary.fromJson(Map<String, dynamic> json){
    return Beneficiary(int.parse(json['id'].toString()), json['ecBeneficiaryName'], int.parse(json['unionId'].toString()), json['unionName'], json['nationalID'], json['secondNationalID'], int.parse(json['dealerId'].toString()), json['dealerName'], int.parse(json['cardNo'].toString()), json['givenMobileNo'], json['image']);
  }

  Map<String, dynamic> toJson(){
    return {
      "id" : this.id,
      "name" : this.name,
      "unionId" : this.unionId,
      "unionName" : this.unionName,
      "nId" : this.nId,
      "sNId" : this.sNId,
      "dealerId" : this.dealerId,
      "dealerName" : this.dealerName,
      "cardNo" : this.cardNo,
      "mobNo" : this.mobNo,
      "image" : this.image
    };
  }
}