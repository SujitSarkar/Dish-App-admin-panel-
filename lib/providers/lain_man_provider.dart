import 'package:admin_app/model/lain_man_model.dart';
import 'package:admin_app/providers/public_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LainManProvider extends PublicProvider{
  LainManModel _lainManModel = LainManModel();
  List<LainManModel> _lainManList=[];

  get lainManModel=> _lainManModel;
  get lainManList=> _lainManList;

  set lainManModel(LainManModel val){
    val= LainManModel();
    _lainManModel = val;
    notifyListeners();
  }

  Future<bool> addNewLainMan(LainManProvider lmProvider)async{
    try{
      int timeStamp = DateTime.now().millisecondsSinceEpoch;
      await FirebaseFirestore.instance.collection('LainMan').doc('+88${lmProvider.lainManModel.phone}').set({
        'id':'+88${lmProvider.lainManModel.phone}',
        'phone':lmProvider.lainManModel.phone,
        'name':lmProvider.lainManModel.name,
        'password':lmProvider.lainManModel.password,
        'nID':lmProvider.lainManModel.nID,
        'fatherName':lmProvider.lainManModel.fatherName,
        'address':lmProvider.lainManModel.address,
        'timeStamp': timeStamp.toString(),
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> getAllLainMan()async{
    try{
      await FirebaseFirestore.instance.collection('LainMan').get().then((snapshot){
        _lainManList.clear();
        snapshot.docChanges.forEach((element) {
          LainManModel lainManModel = LainManModel(
              id: element.doc['id'],
              phone: element.doc['phone'],
              name: element.doc['name'],
              password: element.doc['password'],
              nID: element.doc['nID'],
              fatherName: element.doc['fatherName'],
              address: element.doc['address'],
              timeStamp: element.doc['timeStamp'],
          );
          _lainManList.add(lainManModel);
        });
      });
      notifyListeners();
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }

  Future<bool> deleteLainMan(String id, int index)async{
    try{
      await FirebaseFirestore.instance.collection('LainMan').doc(id).delete().then((value){
        _lainManList.removeAt(index);
        notifyListeners();
      });
      return Future.value(true);
    }catch(error){
      return Future.value(false);
    }
  }
}