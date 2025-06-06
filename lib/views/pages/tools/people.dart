import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/people_model.dart';
import 'package:planora/views/pages/tools/people/people_page.dart';
import 'package:planora/widgets/contact_picker_modal.dart';
import 'package:uuid/uuid.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  List<PeopleModel> people = [];
  Set<int> selectedPeople = <int>{};
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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

  Future<void> addPeopleToHive(PeopleModel people) async {
    await HiveEvents.addPeopleToHive(people);
    getPeople();
  }

  Future<void> deletePeopleFromHive(int index) async {
    await HiveEvents.deletePeopleFromHive(index);
    getPeople();
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
      appBar: AppBar(
        title: Text("People"),
        actions: [
          if (selectedPeople.isNotEmpty) ...[
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.add)),
            IconButton(
              onPressed: () {
                for (var index in selectedPeople) {
                  deletePeopleFromHive(index);
                }
                setState(() {
                  selectedPeople.clear();
                });
              },
              icon: Icon(CupertinoIcons.trash),
            ),
          ],
        ],
      ),
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
                Badge(
                  smallSize: 24,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  offset: Offset(-16, 4),
                  label: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 16,
                  ),
                  isLabelVisible: selectedPeople.contains(index),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onTap: () {
                      if (selectedPeople.isNotEmpty) {
                        setState(() {
                          if (selectedPeople.contains(index)) {
                            selectedPeople.remove(index);
                          } else {
                            selectedPeople.add(index);
                          }
                        });
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PeoplePage(people: people[index]),
                        ),
                      );
                    },
                    onLongPress: () {
                      setState(() {
                        if (selectedPeople.contains(index)) {
                          selectedPeople.remove(index);
                        } else {
                          selectedPeople.add(index);
                        }
                      });
                    },
                    child: CircleAvatar(
                      radius: radius,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.9),
                      child: ClipOval(
                        child:
                            people[index].imageUrl.isNotEmpty
                                ? Image.network(
                                  people[index].imageUrl,
                                  fit: BoxFit.cover,
                                )
                                : CircleAvatar(
                                  radius: radius / 2,
                                  backgroundColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.secondaryFixed,
                                  child: Text(
                                    people[index].name
                                        .split(' ')
                                        .map((name) => name[0])
                                        .join(),
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSecondaryFixed,
                                    ),
                                  ),
                                ),
                      ),
                    ),
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
                                      onContactSelected: (contact) {
                                        addPeopleToHive(
                                          PeopleModel(
                                            id: Uuid().v4(),
                                            name: contact.displayName,
                                            imageUrl: "",
                                            email:
                                                contact.emails
                                                    .map(
                                                      (email) => email.address,
                                                    )
                                                    .toList(),
                                            phone:
                                                contact.phones
                                                    .map(
                                                      (phone) => phone.number,
                                                    )
                                                    .toList(),
                                          ),
                                        );
                                      },
                                    )
                                    : ContactPickerModalAndroid(
                                      onContactSelected: (contact) {
                                        addPeopleToHive(
                                          PeopleModel(
                                            id: Uuid().v4(),
                                            name: contact.displayName,
                                            imageUrl: "",
                                            email:
                                                contact.emails
                                                    .map(
                                                      (email) => email.address,
                                                    )
                                                    .toList(),
                                            phone:
                                                contact.phones
                                                    .map(
                                                      (phone) => phone.number,
                                                    )
                                                    .toList(),
                                          ),
                                        );
                                      },
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
                                    if (nameController.text.isNotEmpty &&
                                        (emailController.text.isNotEmpty ||
                                            phoneController.text.isNotEmpty)) {
                                      addPeopleToHive(
                                        PeopleModel(
                                          id: Uuid().v4(),
                                          name: nameController.text,
                                          imageUrl: "",
                                          email: emailController.text.split(
                                            ",",
                                          ),
                                          phone: phoneController.text.split(
                                            ",",
                                          ),
                                        ),
                                      );
                                    }
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
                                            controller: nameController,
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
                                            controller: emailController,
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
                                            controller: phoneController,
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
