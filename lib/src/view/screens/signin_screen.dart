import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/utils/constants.dart';
import 'package:nadi/src/view/screens/create_account_screen.dart';
import 'package:nadi/src/viewmodel/login_viewmodel.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  LoginViewModel loginViewModel = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
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
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width,
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: loginViewModel.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  else if(GetUtils.isEmail(value) == false){
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: loginViewModel.passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  else if(value.length < 6){
                    return 'Password must be atleast 6 characters';
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
                    hintText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey)),
                // onChanged: createAccountViewModel.setUsername,
              ),
              const SizedBox(
                height: 32,
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
                   if( _formKey.currentState!.validate()){
                      loginViewModel.login();
                   }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(() => CreateAccountScreen());
                  },
                  child: const Text('Don\'t have an account?')),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
