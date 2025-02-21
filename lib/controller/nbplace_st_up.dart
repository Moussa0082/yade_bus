import 'package:get/get.dart';

class StatusController extends GetxController {
  var status = false.obs;
  var isUserInBrowser = false.obs;
  String? accessToken;
  String? payToken;
  String? orderIds;
  double? amounts;

  void updateStatus(bool value) {
    status.value = value;
  }
  void updateIsBrowserStatus(bool value) {
    isUserInBrowser.value = value;
  }
}
