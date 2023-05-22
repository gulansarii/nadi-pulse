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
        body: Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.pexels.com/photos/5214996/pexels-photo-5214996.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                  fit: BoxFit.cover,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: welcomeController.isLoading.value
                    ? BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: welcomeController.isLoading.value
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24))),
                          height: 250,
                          width: Get.width,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Nadi Pulse',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
                                const Text(
                                  'Nadi Pulse is a mobile application that allows you to book appointments with doctors and get medical advice from the comfort of your home.',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 4,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => const SignInScreen());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ConstantThings.accentColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.grey[300]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: Get.width / 4,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.to(() => CreateAccountScreen());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ConstantThings.accentColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              color: Colors.grey[300]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const SizedBox())
          ],
        ),
      );
    });
  }
}
