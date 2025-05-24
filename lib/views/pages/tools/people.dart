import 'package:flutter/material.dart';
import 'package:planora/utils/font_weights.dart';

class People extends StatelessWidget {
  const People({super.key});

  static const templateNames = [
    "Hansel Presley Saldanha",
    "Eben Dsouza",
    "Umraan Mastan",
  ];

  static const lastActiveDate = [
    "19th May 2024",
    "09th May 2024",
    "23rd April 2024",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("People")),
      body: Center(
        child: ListView.separated(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          separatorBuilder:
              (context, index) => Divider(color: Colors.transparent),
          itemCount: 3,
          itemBuilder:
              (context, index) => ListTile(
                minTileHeight: 100.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                tileColor: Theme.of(context).colorScheme.primary,
                title: Text(
                  templateNames[index],
                  style: TextStyle(
                    fontWeight: FontWeights.regular,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                // subtitle: Text("Country: USA"),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                subtitle: Text(
                  "Last Active on: ${lastActiveDate[index]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                visualDensity: VisualDensity.comfortable,
                titleAlignment: ListTileTitleAlignment.center,
              ),
        ),
      ),
    );
  }
}
