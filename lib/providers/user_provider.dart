import 'package:admin_app/model/user_model.dart';
import 'package:admin_app/providers/public_provider.dart';

class UserProvider extends PublicProvider{
  UserModel _userModel = UserModel();

  get userModel=> _userModel;

  set userModel(UserModel val){
    val= UserModel();
    _userModel = val;
    notifyListeners();
  }
}