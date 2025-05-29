import 'package:flutter/material.dart';

class People extends StatelessWidget {
  const People({super.key});

  static const templateNames = [
    "Noel Pinto",
    "Hansel Presley Saldanha",
    "Eben Dsouza",
    "Umraan Mastan",
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const circlesPerRow = 3;
    const spacing = 24.0;
    final totalSpacing = (circlesPerRow - 1) * spacing;
    final diameter = (screenWidth - totalSpacing) / circlesPerRow;
    final radius = diameter / 2;
    return Scaffold(
      appBar: AppBar(title: Text("People")),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 4.0),
        child: Wrap(
          runSpacing: 24.0,
          spacing: 16.0,
          children: List.generate(
            templateNames.length,
            (index) => Column(
              spacing: 8.0,
              children: [
                CircleAvatar(
                  radius: radius,
                  foregroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/${index + 1}.jpg",
                  ),
                ),
                Text(
                  templateNames[index].split(" ").join("\n"),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
