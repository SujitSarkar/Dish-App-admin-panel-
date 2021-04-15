import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showSnackBar(BuildContext context, message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
      backgroundColor: color,
      elevation: 0,
    ),
  );
}

void showLoadingDialog(String status)=> EasyLoading.show(status: status);

void closeLoadingDialog()=> EasyLoading.dismiss();

void showSuccessMgs(String status)=> EasyLoading.showSuccess(status);

void showErrorMgs(String status)=> EasyLoading.showError(status);

void showToast(String status)=> EasyLoading.showToast(status);

void showInfo(String status)=> EasyLoading.showInfo(status);

// EasyLoading.showProgress(0.3, status: 'downloading...');
// EasyLoading.showSuccess('Great Success!');
// EasyLoading.showError('Failed with Error');
// EasyLoading.showInfo('Useful Information.');
// EasyLoading.showToast('Toast');
// EasyLoading.dismiss();
