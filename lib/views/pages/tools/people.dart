import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/views/pages/tools/people/create_new_contact.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      final contacts = await FastContacts.getAllContacts();
      setState(() {
        allContacts = contacts;
        filteredContacts = contacts;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      filteredContacts =
          allContacts
              .where(
                (contact) => contact.structuredName!.givenName
                    .toLowerCase()
                    .contains(value.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  void dispose() {
    contactSearchController.dispose();
    super.dispose();
  }

  static const templateNames = [
    "Noel Pinto",
    "Hansel Presley Saldanha",
    "Eben Dsouza",
    "Umraan Mastan",
  ];

  final TextEditingController contactSearchController = TextEditingController();

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
                                    ? CupertinoPageScaffold(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      navigationBar: CupertinoNavigationBar(
                                        backgroundColor:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                        automaticallyImplyLeading: false,
                                        middle: Text(
                                          "Contact List",
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                            fontWeight: FontWeights.regular
                                          ),
                                        ),
                                        trailing: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          sizeStyle: CupertinoButtonSize.medium,
                                          child: Text(
                                            "Close",
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: CupertinoSearchTextField(
                                              onChanged: (value) {
                                                _onSearchChanged(value);
                                              },
                                              onSubmitted: (value) {
                                                _onSearchChanged(value);
                                              },
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                              controller:
                                                  contactSearchController,
                                              placeholder: 'Search',
                                            ),
                                          ),
                                          CupertinoListSection.insetGrouped(
                                            backgroundColor:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                            children:
                                                filteredContacts
                                                    .map(
                                                      (
                                                        contact,
                                                      ) => CupertinoListTile.notched(
                                                        key: ValueKey(
                                                          contact
                                                              .structuredName!
                                                              .givenName,
                                                        ),
                                                        onTap:
                                                            () => Navigator.pop(
                                                              context,
                                                            ),
                                                        trailing:
                                                            const CupertinoListTileChevron(),
                                                        leading: CircleAvatar(
                                                          child: Text(
                                                            contact
                                                                .structuredName!
                                                                .givenName
                                                                .substring(
                                                                  0,
                                                                  1,
                                                                ),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          contact
                                                              .structuredName!
                                                              .givenName,
                                                          style: TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .onSurface,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ],
                                      ),
                                    )
                                    : Scaffold(
                                      appBar: AppBar(
                                        title: Text("Contact List"),
                                        automaticallyImplyLeading: false,
                                        actions: [
                                          IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      body: ListView.builder(
                                        itemCount: filteredContacts.length,
                                        itemBuilder: (context, index) {
                                          final contact =
                                              filteredContacts[index];
                                          return ListTile(
                                            leading: CircleAvatar(
                                              child: Text(
                                                contact
                                                    .structuredName!
                                                    .givenName
                                                    .substring(
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              contact.structuredName!.givenName,
                                            ),
                                            trailing: Icon(Icons.arrow_forward),
                                            onTap: () {},
                                          );
                                        },
                                      ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNewContact(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
