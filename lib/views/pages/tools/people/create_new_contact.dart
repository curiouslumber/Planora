import 'package:flutter/material.dart';

class CreateNewContact extends StatelessWidget {
  const CreateNewContact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create New Contact")),
      body: Center(child: Text("Create New Contact")),
    );
  }
}
