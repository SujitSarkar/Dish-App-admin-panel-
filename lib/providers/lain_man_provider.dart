import 'package:admin_app/model/lain_man_model.dart';
import 'package:flutter/material.dart';

class LainManProvider extends ChangeNotifier{
  LainManModel _lainManModel = LainManModel();

  get lainManModel=> _lainManModel;

  set lainManModel(LainManModel val){
    val= LainManModel();
    _lainManModel = val;
    notifyListeners();
  }
}