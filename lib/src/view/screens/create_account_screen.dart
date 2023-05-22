import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../viewmodel/create_account_viewmodel.dart';
import '../widgets/radio_button_widget.dart';

class CreateAccountScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  final CreateAccountViewModel createAccountViewModel =
      Get.put(CreateAccountViewModel());

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(createAccountViewModel.isPatient);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     createAccountViewModel.createAccount();
      //   },
      //   child: const Icon(Icons.arrow_forward),
      // ),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: Get.width,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: createAccountViewModel.nameTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      hintText: 'Name',
                      labelStyle: TextStyle(color: Colors.grey)),
                  // onChanged: createAccountViewModel.setUsername,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  controller: createAccountViewModel.emailTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    } else if (GetUtils.isEmail(value) == false) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      hintText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey)),
                  // onChanged: createAccountViewModel.setUsername,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  readOnly: true,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            color: Colors.white,
                            child: GooglePlaceAutoCompleteTextField(
                              textEditingController:
                                  createAccountViewModel.addressTextController,
                              googleAPIKey:
                                  "AIzaSyBhPteA6FOMIaQqRIpHk7xLM5I4BN3_zMs",
                              inputDecoration: const InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  hintText: 'Search Address',
                                  labelStyle: TextStyle(color: Colors.grey)),
                              countries: const ["in", "fr"],
                              isLatLngRequired: true,
                              getPlaceDetailWithLatLng:
                                  (Prediction prediction) {
                                print("placeDetails${prediction.lng}");
                                print("placeDetails${prediction.lat}");
                                createAccountViewModel.latitude =
                                    prediction.lat!;
                                createAccountViewModel.longitude =
                                    prediction.lng!;
                              },
                              itmClick: (Prediction prediction) {
                                createAccountViewModel.addressTextController
                                    .text = prediction.description!;

                                // print("placeDetails${prediction.lng}");
                                String data = prediction.description!;

                                List<String> parts = data.split(", ");
                                createAccountViewModel.city =
                                    parts[parts.length - 3];
                                createAccountViewModel.state =
                                    parts[parts.length - 2];
                                createAccountViewModel.completeAddress =
                                    prediction.description!;

                                print("city ${createAccountViewModel.city}");
                                print("state ${createAccountViewModel.state}");
                                print(
                                    "complete Address ${createAccountViewModel.completeAddress}");

                                // print(prediction);
                                Get.back();
                              },
                            ),
                          ),
                        );
                      },
                    );
                    //   Get.bottomSheet(Container(
                  },
                  controller: createAccountViewModel.addressTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      hintText: 'Address',
                      labelStyle: TextStyle(color: Colors.grey)),
                  // onChanged: createAccountViewModel.setUsername,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  controller: createAccountViewModel.passwordTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Password should be atleast 6 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      hintText: 'Create Password',
                      labelStyle: TextStyle(color: Colors.grey)),
                  // onChanged: createAccountViewModel.setUsername,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.done,

                  controller:
                      createAccountViewModel.confirmPasswordTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter confirm password';
                    } else {
                      if (value !=
                          createAccountViewModel.passwordTextController.text) {
                        return 'Password and confirm password should be same';
                      }
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      hintText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.grey)),
                  // onChanged: createAccountViewModel.setUsername,
                ),
                const SizedBox(
                  height: 16,
                ),
                const RadioButtonsWidget(),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    if (createAccountViewModel.isLoading.value == false) {
                      createAccountViewModel.createAccount();
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: ConstantThings.accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 48,
                      width: Get.width,
                      alignment: Alignment.center,
                      child: Obx(
                        () => createAccountViewModel.isLoading.value
                            ? SizedBox(
                                height: 50,
                                width: 50,
                                child: LoadingAnimationWidget.waveDots(
                                    color: Colors.white,
                                    // rightDotColor: Colors.white,
                                    size: 45),
                              )
                            : const Text(
                                'Create Account',
                                style: TextStyle(color: Colors.white),
                              ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
