import 'package:admin_app/model/lain_man_model.dart';
import 'package:admin_app/providers/public_provider.dart';

class LainManProvider extends PublicProvider{
  LainManModel _lainManModel = LainManModel();

  get lainManModel=> _lainManModel;

  set lainManModel(LainManModel val){
    val= LainManModel();
    _lainManModel = val;
    notifyListeners();
  }
}