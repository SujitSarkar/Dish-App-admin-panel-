import 'package:admin_app/model/problem_model.dart';
import 'package:admin_app/model/user_model.dart';
import 'package:admin_app/providers/public_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends PublicProvider{
  UserModel _userModel = UserModel();
  List<UserModel> _allUserList = [];
  List<UserModel> _pendingBillUserList = [];
  List<UserModel> _paidBillUserList = [];
  List<ProblemModel> _userProblemList = [];

  get userModel=> _userModel;
  get allUserList=> _allUserList;
  get pendingBillUserList=> _pendingBillUserList;
  get paidBillUserList=> _paidBillUserList;
  get userProblemList=> _userProblemList;

  set userModel(UserModel val){
    val= UserModel();
    _userModel = val;
    notifyListeners();
  }

  Future<bool> addNewUser(UserProvider uProvider)async{
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('Users').doc('+88${uProvider.userModel.phone}').set({
        'id':'+88${uProvider.userModel.phone}',
        'phone':uProvider.userModel.phone,
        'name':uProvider.userModel.name,
        'password':uProvider.userModel.password,
        'nID':uProvider.userModel.nID,
        'fatherName':uProvider.userModel.fatherName,
        'address':uProvider.userModel.address,
        'timeStamp': timeStamp.toString(),
        'monthYear': null,
        'billingState':null
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getAllUser()async{
    try{
      await FirebaseFirestore.instance.collection('Users').get().then((snapshot){
        _allUserList.clear();
        snapshot.docChanges.forEach((element) {
          UserModel userModel = UserModel(
            id: element.doc['id'],
            phone: element.doc['phone'],
            name: element.doc['name'],
            password: element.doc['password'],
            nID: element.doc['nID'],
            fatherName: element.doc['fatherName'],
            address: element.doc['address'],
            timeStamp: element.doc['timeStamp'],
            monthYear: element.doc['monthYear'],
            billingState: element.doc['billingState']
          );
          _allUserList.add(userModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getPendingBillUser()async{
    final String monthYear = '${DateTime.now().month}/${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('Users').get().then((snapshot){
        _pendingBillUserList.clear();
        snapshot.docChanges.forEach((element) {
          if(monthYear != element.doc['monthYear'] || element.doc['billingState']=='pending'){
            UserModel userModel = UserModel(
              id: element.doc['id'],
              phone: element.doc['phone'],
              name: element.doc['name'],
              password: element.doc['password'],
              nID: element.doc['nID'],
              fatherName: element.doc['fatherName'],
              address: element.doc['address'],
              timeStamp: element.doc['timeStamp'],
              monthYear: element.doc['monthYear'],
              billingState: element.doc['billingState']
            );
            _pendingBillUserList.add(userModel);
          }
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getPaidBillUser()async{
    final String monthYear = '${DateTime.now().month}/${DateTime.now().year}';
    try{
      await FirebaseFirestore.instance.collection('Users').get().then((snapshot){
        _paidBillUserList.clear();
        snapshot.docChanges.forEach((element) {
          if(monthYear == element.doc['monthYear'] && element.doc['billingState']=='approved'){
            UserModel userModel = UserModel(
              id: element.doc['id'],
              phone: element.doc['phone'],
              name: element.doc['name'],
              password: element.doc['password'],
              nID: element.doc['nID'],
              fatherName: element.doc['fatherName'],
              address: element.doc['address'],
              timeStamp: element.doc['timeStamp'],
              monthYear: element.doc['monthYear'],
              billingState: element.doc['billingState']
            );
            _paidBillUserList.add(userModel);
          }
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getUserProblem()async{
    try{
      await FirebaseFirestore.instance.collection('UserProblems').orderBy('timeStamp',descending: true).get().then((snapshot){
        _userProblemList.clear();
        snapshot.docChanges.forEach((element) {
          ProblemModel problemModel = ProblemModel(
              id: element.doc['id'],
              phone: element.doc['phone'],
              name: element.doc['name'],
              address: element.doc['address'],
              timeStamp: element.doc['timeStamp'],
              problem: element.doc['problem'],
              state: element.doc['state']
          );
          _userProblemList.add(problemModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> payUserBill(DateTime date,String billType, String userPhone,String userID,String name,String amount)async{
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('UserBillingInfo').doc('$userID$timeStamp').set({
        'id': '$userID$timeStamp',
        'name': name,
        'userID': userID,
        'userPhone': userPhone,
        'monthYear': '${date.month}/${date.year}',
        'billType': billType,
        'billingNumber': 'admin/lainMan',
        'transactionId': 'admin/lainMan',
        'amount': amount,
        'state': 'approved',
        'payDate': '${DateTime.now().month}/${DateTime.now().year}',
        'timeStamp': timeStamp.toString()
      }).then((value)async{
        await FirebaseFirestore.instance.collection('Users').doc(userID).update({
          'billingState': 'approved',
          'monthYear': '${date.month}/${date.year}',
        });
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
}