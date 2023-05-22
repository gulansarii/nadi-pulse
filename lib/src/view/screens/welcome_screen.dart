import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:nadi/src/view/screens/create_account_screen.dart';
import 'package:nadi/src/view/screens/signin_screen.dart';
import 'package:nadi/src/viewmodel/welcome_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final WelcomeController welcomeController = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WelcomeController>(builder: (welcomeController) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //   image: NetworkImage(
                  //       "https://images.pexels.com/photos/5214996/pexels-photo-5214996.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                  //   fit: BoxFit.cover,
                  // ),
                  ),
              // child: AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 500),
              //   child: welcomeController.isLoading.value
              //       ? BackdropFilter(
              //           filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              //           child: Container(
              //             color: Colors.black.withOpacity(0.5),
              //           ),
              //         )
              //       : const SizedBox(),
              // ),
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: welcomeController.isLoading.value
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: kToolbarHeight * 2,
                            ),
                            Text("ＮＰＵＬＳＥ",
                                style: TextStyle(
                                    color: ConstantThings.accentColor
                                        .withOpacity(.7),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Image.asset(
                              'assets/welcome_image.png',
                              fit: BoxFit.cover,
                              width: Get.width - 100,
                              height: Get.width - 100,
                            ),
                            const SizedBox(
                              height: 120,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const SignInScreen());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: ConstantThings.accentColor,
                                    borderRadius: BorderRadius.circular(16)),
                                height: 40,
                                width: Get.width / 2,
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => CreateAccountScreen());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16)),
                                height: 48,
                                width: Get.width,
                                child: const Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                      color: ConstantThings.accentColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                          ],
                        ),
                      )
                    : const SizedBox())
          ],
        ),
      );
    });
  }
}
