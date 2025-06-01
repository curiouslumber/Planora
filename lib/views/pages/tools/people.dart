import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/people_model.dart';
import 'package:planora/widgets/contact_picker_modal.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  List<PeopleModel> people = [];

  @override
  void initState() {
    super.initState();
    getPeople();
  }

  Future<void> getPeople() async {
    final contacts = await HiveEvents.getPeopleFromHive();
    setState(() {
      people = contacts;
    });
  }

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
            people.length,
            (index) => Column(
              key: ValueKey(people[index].hashCode),
              spacing: 8.0,
              children: [
                CircleAvatar(
                  radius: radius,
                  foregroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/${index + 1}.jpg",
                  ),
                ),
                Text(
                  people[index].name,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        overlayOpacity: 0.4,
        spacing: 12,
        spaceBetweenChildren: 12,
        childrenButtonSize: const Size(56, 56),
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: Icon(Icons.contact_page),
            label: 'Add From Contacts',
            labelBackgroundColor: Colors.transparent,
            labelShadow: List.empty(),
            onTap: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder:
                    (context) => CupertinoContextMenu.builder(
                      actions: [
                        CupertinoContextMenuAction(
                          child: Text("Add From Contacts"),
                          onPressed: () {},
                        ),
                      ],
                      builder: (
                        BuildContext context,
                        Animation<double> animation,
                      ) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          width: double.infinity,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? ContactPickerModalIOS(
                                      appContacts: people,
                                    )
                                    : ContactPickerModalAndroid(
                                      appContacts: people,
                                    ),
                          ),
                        );
                      },
                    ),
              );
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: Icon(Icons.create),
            label: 'Create New',
            labelBackgroundColor: Colors.transparent,
            labelShadow: List.empty(),
            onTap: () {
              showCupertinoModalPopup<void>(
                context: context,
                builder:
                    (context) => CupertinoContextMenu.builder(
                      actions: [
                        CupertinoContextMenuAction(
                          child: Text("New Contact"),
                          onPressed: () {},
                        ),
                      ],
                      builder: (
                        BuildContext context,
                        Animation<double> animation,
                      ) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: CupertinoPageScaffold(
                              navigationBar: CupertinoNavigationBar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                leading: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  sizeStyle: CupertinoButtonSize.medium,
                                  child: Text(
                                    "Close",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                middle: Text(
                                  "New Contact",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                trailing: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  sizeStyle: CupertinoButtonSize.medium,
                                  child: Text(
                                    "Done",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: 16.0),
                                    Column(
                                      spacing: 16.0,
                                      children: [
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          foregroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                          child: Icon(Icons.person),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 8.0,
                                          children: [
                                            CupertinoButton.filled(
                                              sizeStyle:
                                                  CupertinoButtonSize.small,
                                              onPressed: () {},
                                              child: Text('Add Photo'),
                                            ),
                                            CupertinoButton.filled(
                                              sizeStyle:
                                                  CupertinoButtonSize.small,
                                              onPressed: () {},
                                              child: Row(
                                                spacing: 4.0,
                                                children: [
                                                  Icon(CupertinoIcons.sparkles),
                                                  Text("AI Generate"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    CupertinoFormSection(
                                      backgroundColor: Colors.transparent,
                                      children: [
                                        CupertinoFormRow(
                                          padding: EdgeInsets.zero,
                                          child: CupertinoTextField(
                                            placeholder: 'Name',
                                            keyboardType: TextInputType.name,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        CupertinoFormRow(
                                          padding: EdgeInsets.zero,
                                          child: CupertinoTextField(
                                            placeholder: 'Email',
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                        CupertinoFormRow(
                                          padding: EdgeInsets.zero,
                                          child: CupertinoTextField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
                                            placeholder: 'Phone Number',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.zero,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
