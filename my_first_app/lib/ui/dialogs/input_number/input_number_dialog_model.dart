import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/model/no_acc.dart';
import 'package:my_first_app/services/shared_pref_service.dart';
import 'package:stacked/stacked.dart';

class InputNumberDialogModel extends BaseViewModel {
  final _sharedPref = locator<SharedPreferenceService>();
  TextEditingController phonNumTextController = TextEditingController();

  Future<void> saveDocument() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String id = DateTime.timestamp().millisecondsSinceEpoch.toString();
      NoAcc acc = NoAcc(uid: id, phonenumber: phonNumTextController.text);
      await firestore.collection("users").doc(id).set(acc.toJson());
      _sharedPref.saveNoAcc(acc);

      print('Document added successfully');
    } catch (e) {
      print('Error adding document: $e');
    }
  }
}
