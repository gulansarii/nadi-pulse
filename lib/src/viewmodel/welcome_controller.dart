import 'package:get/get.dart';

class WelcomeController extends GetxController {
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 1800), () {
      isLoading.value = true;
      update();
    });
    super.onInit();
  }
}
