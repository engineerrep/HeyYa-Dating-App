import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heyya/app/core/utils/get_snackbar.dart';

class HeySnackBar {
  static showError(String msg) {
    GetSnackbarTool.showText(text: msg, type: GetSnackbarType.failure);
  }
  
  static showInfo(String msg) {
    GetSnackbarTool.showText(text: msg, type: GetSnackbarType.notification);
  }

  static void showSuccess(String msg) {
    GetSnackbarTool.showText(text: msg, type: GetSnackbarType.success);
  }

  static void showWarning(String msg) {
    GetSnackbarTool.showText(text: msg, type: GetSnackbarType.warning);
  }
}
