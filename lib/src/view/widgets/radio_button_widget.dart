import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../viewmodel/create_account_viewmodel.dart';

class RadioButtonsWidget extends StatefulWidget {
  const RadioButtonsWidget({super.key});

  @override
  _RadioButtonsWidgetState createState() => _RadioButtonsWidgetState();
}

class _RadioButtonsWidgetState extends State<RadioButtonsWidget> {
  CreateAccountViewModel createAccountViewModel =Get.find();
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = 'Patient'; // Set the initial selection
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(
          // Spacer is used to push the radio buttons to the left and right
          flex: 1,
        ),
        SizedBox(
          width: Get.width / 2.5,
          // height: 100,
          child: RadioListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Patient'),
            value: 'Patient',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
                createAccountViewModel.isPatient =  true;
              });
            },
          ),
        ),
        SizedBox(
          width: Get.width / 2.5,
          // height: 100,
          child: RadioListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Doctor'),
            value: 'Doctor',
            groupValue: _selectedRole,
            onChanged: (value) {
              setState(() {
                _selectedRole = value;
                                createAccountViewModel.isPatient =  false;
                                

              });
            },
          ),
        ),
        const Spacer(
          // Spacer is used to push the radio buttons to the left and right
          flex: 1,
        )
      ],
    );
  }
}
