import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:nadi/src/view/widgets/radio_button_widget.dart';

import '../../viewmodel/create_account_viewmodel.dart';

class CreateAccountScreen extends StatelessWidget {
  final CreateAccountViewModel createAccountViewModel =
      Get.put(CreateAccountViewModel());

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                controller: createAccountViewModel.emailTextController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
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
                                hintText: 'Choose Address',
                                labelStyle: TextStyle(color: Colors.grey)),
                            countries: ["in", "fr"],
                            isLatLngRequired: true,
                            getPlaceDetailWithLatLng: (Prediction prediction) {
                              print("placeDetails" + prediction.lng.toString());
                            },
                            itmClick: (Prediction prediction) {
                              createAccountViewModel.addressTextController
                                  .text = prediction.description!;
                              Get.back();
                              // controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
                            },
                          ),
                        ),
                      );
                    },
                  );

                  //   Get.bottomSheet(Container(
                  //     height: Get.height / 2,
                  //     color: Colors.white,
                  //     child: GooglePlaceAutoCompleteTextField(
                  //         textEditingController: TextEditingController(),
                  //         googleAPIKey:
                  //             "AIzaSyBhPteA6FOMIaQqRIpHk7xLM5I4BN3_zMs ",
                  //         inputDecoration: InputDecoration(),
                  //         countries: [
                  //           "in",
                  //           "fr"
                  //         ], // optional by default null is set
                  //         isLatLngRequired:
                  //             true, // if you required coordinates from place detail
                  //         getPlaceDetailWithLatLng: (Prediction prediction) {
                  //           // this method will return latlng with place detail
                  //           print("placeDetails" + prediction.lng.toString());
                  //         }, // this callback is called when isLatLngRequired is true
                  //         itmClick: (Prediction prediction) {
                  //           //  controller.text=prediction.description;
                  //           //   controller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));
                  //         }),
                  //   ));
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
                controller: createAccountViewModel.passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
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
                controller:
                    createAccountViewModel.confirmPasswordTextController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter confirm password';
                  } else {
                    if (value !=
                        createAccountViewModel.passwordController.text) {
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
              RadioButtonsWidget(),
              const SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ConstantThings.accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 48,
                width: Get.width,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }

                    // createAccountViewModel.createAccount();
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
