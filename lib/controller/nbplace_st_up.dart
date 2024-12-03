import 'package:get/get.dart';

class StatusController extends GetxController {
  var status = false.obs;

  void updateStatus(bool value) {
    status.value = value;
  }
}
