import 'package:flutter/material.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      body: Center(
        child: GridView.builder(
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          padding: EdgeInsets.all(8.0),
          itemBuilder:
              (context, index) => GridTile(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    index.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(Icons.add),
        onPressed: () => {},
      ),
    );
  }
}
