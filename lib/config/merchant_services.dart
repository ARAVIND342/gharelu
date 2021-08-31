import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gharelu/screen/Home.dart';

class MerchantServices{
  getTopMerchants(){
    return FirebaseFirestore.instance.collection('Selling details').orderBy('Price').snapshots();

  }
}


