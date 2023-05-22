import 'package:get/get.dart';

class WelcomeController extends GetxController {
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    Future.delayed(const Duration(milliseconds: 0), () {
      isLoading.value = true;
      update();
    });
    super.onInit();
  }
}
