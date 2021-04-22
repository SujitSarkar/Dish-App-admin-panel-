import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicProvider extends ChangeNotifier{
  bool _internetConnected=true;
  get internetConnected=> _internetConnected;

  Future<void> checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());

    if (result == ConnectivityResult.none) {
      _internetConnected = false;
      notifyListeners();
    } else if (result == ConnectivityResult.mobile) {
      _internetConnected = true;
      notifyListeners();
    } else if (result == ConnectivityResult.wifi) {
      _internetConnected = true;
      notifyListeners();
    }
  }

  Future<String> getPrefPhone()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return Future.value(pref.get('phone'));
  }
  
  Future<bool> updateAddressAndCustomerCare(String id,  Map<String, String> dataMap)async{
    try{
      await FirebaseFirestore.instance.collection('OfficeDetails').doc(id).update(dataMap);
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
  Future<bool> updateAboutUs(String id, String aboutUs,String service)async{
    try{
      await FirebaseFirestore.instance.collection('OfficeDetails').doc(id).update({
        'aboutUs': aboutUs,
        'ourService':service
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }


  }
