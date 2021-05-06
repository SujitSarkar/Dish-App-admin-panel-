import 'package:admin_app/model/billing_info_model.dart';
import 'package:admin_app/providers/public_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillingProvider extends PublicProvider{

  List<BillingInfoModel> _approvedBillList=[];
  List<BillingInfoModel> _pendingBillList=[];

  get approvedBillList=> _approvedBillList;
  get pendingBillList=> _pendingBillList;


  Future<bool> getApprovedBillingInfo()async{
    try{
      await FirebaseFirestore.instance.collection('UserBillingInfo').where('state', isEqualTo: 'approved').orderBy('timeStamp',descending: true).get().then((snapshot){
        _approvedBillList.clear();
        snapshot.docChanges.forEach((element) {
          BillingInfoModel billingInfo = BillingInfoModel(
            id: element.doc['id'],
            name: element.doc['name'],
            userPhone: element.doc['userPhone'],
            userID: element.doc['userID'],
            monthYear:element.doc['monthYear'],
            amount: element.doc['amount'],
            billType:element.doc['billType'],
            billingNumber:element.doc['billingNumber'],
            transactionId:element.doc['transactionId'],
            state:element.doc['state'],
            payDate: element.doc['payDate'],
            timeStamp: element.doc['timeStamp'],
          );
          _approvedBillList.add(billingInfo);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getPendingBillingInfo()async{
  try{
    await FirebaseFirestore.instance.collection('UserBillingInfo').where('state', isEqualTo: 'pending').orderBy('timeStamp',descending: true).get().then((snapshot){
      _pendingBillList.clear();
      snapshot.docChanges.forEach((element) {
        BillingInfoModel billingInfo = BillingInfoModel(
          id: element.doc['id'],
          name: element.doc['name'],
          userPhone: element.doc['userPhone'],
          userID: element.doc['userID'],
          monthYear:element.doc['monthYear'],
          amount: element.doc['amount'],
          billType:element.doc['billType'],
          billingNumber:element.doc['billingNumber'],
          transactionId:element.doc['transactionId'],
          state:element.doc['state'],
          payDate: element.doc['payDate'],
          timeStamp: element.doc['timeStamp'],
        );
        _pendingBillList.add(billingInfo);
      });
    });
    notifyListeners();
    return Future.value(true);
  }catch(error){
    return Future.value(false);
  }
}

Future<bool> approveUserBill(String id, String userID)async{
    try{
      await FirebaseFirestore.instance.collection('UserBillingInfo').doc(id).update({
        'state':'approved'
      }).then((value)async{
        await FirebaseFirestore.instance.collection('Users').doc(userID).update({
          'billingState': 'approved',
        });
        await getPendingBillingInfo();
        notifyListeners();
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
}
}