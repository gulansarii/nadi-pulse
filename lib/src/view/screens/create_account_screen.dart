import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nadi/src/viewmodel/login_viewmodel.dart';
import '../../viewmodel/create_account_viewmodel.dart';

class CreateAccountScreen extends StatelessWidget {
  final CreateAccountViewModel createAccountViewModel =
      Get.put(CreateAccountViewModel());

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createAccountViewModel.createAccount();
        },
        child: const Icon(Icons.arrow_forward),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: createAccountViewModel.usernameController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.black26,
                  ),
                ),
                isDense: true,
                labelText: 'Name',
              ),
              // onChanged: createAccountViewModel.setUsername,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: createAccountViewModel.passwordController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.black26,
                  ),
                ),
                isDense: true,
                labelText: '  Email',
              ),
              obscureText: true,
              // onChanged: createAccountViewModel.setPassword,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: createAccountViewModel.passwordController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                    color: Colors.black26,
                  ),
                ),
                isDense: true,
                labelText: 'Address',
              ),
              obscureText: true,
              // onChanged: createAccountViewModel.setPassword,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
