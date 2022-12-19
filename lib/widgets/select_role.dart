import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class SelectRole extends StatelessWidget {
  String dropDownValue;

  SelectRole([this.dropDownValue = 'Passenger']);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      elevation: 5,
      dropdownColor: Colors.grey,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        label: Text('Select Your Role'),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      value: dropDownValue,
      onChanged: (newRole) {
        dropDownValue = newRole.toString();
      },
      items: ['Driver', "Passenger"].map((newItem) {
        return DropdownMenuItem(
          value: newItem,
          child: Text(newItem),
        );
      }).toList(),
    );
  }
}
