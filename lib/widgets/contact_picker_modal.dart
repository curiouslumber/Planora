import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:planora/models/people_model.dart';

class ContactPickerModalIOS extends StatefulWidget {
  const ContactPickerModalIOS({super.key, required this.appContacts});

  final List<PeopleModel> appContacts;

  @override
  State<ContactPickerModalIOS> createState() => _ContactPickerModalIOSState();
}

class _ContactPickerModalIOSState extends State<ContactPickerModalIOS> {
  final TextEditingController contactSearchController = TextEditingController();

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
      final uniqueContacts = <Contact>[];
      for (final contact in contacts) {
        if (!uniqueContacts.any(
          (c) =>
              c.structuredName?.givenName ==
                  contact.structuredName?.givenName &&
              ((c.emails.isNotEmpty &&
                      contact.emails.isNotEmpty &&
                      c.emails.first == contact.emails.first) ||
                  (c.phones.isNotEmpty &&
                      contact.phones.isNotEmpty &&
                      c.phones.first == contact.phones.first)),
        )) {
          uniqueContacts.add(contact);
        }
      }
      setState(() {
        allContacts = uniqueContacts;
        filteredContacts = uniqueContacts;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    contactSearchController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        automaticallyImplyLeading: false,
        middle: Text(
          "Contact List",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeights.regular,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          sizeStyle: CupertinoButtonSize.medium,
          child: Text(
            "Close",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CupertinoSearchTextField(
              onChanged: (value) {
                _onSearchChanged(value);
              },
              onSubmitted: (value) {
                _onSearchChanged(value);
              },
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              controller: contactSearchController,
              placeholder: 'Search',
            ),
          ),
          if (filteredContacts.isEmpty)
            const CupertinoListTile.notched(
              title: Text(
                'No contacts found',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          if (filteredContacts.isNotEmpty)
            CupertinoListSection.insetGrouped(
              backgroundColor: Theme.of(context).colorScheme.surface,
              children:
                  filteredContacts
                      .map(
                        (contact) => CupertinoListTile.notched(
                          key: ValueKey(contact.id),
                          onTap: () {
                            Navigator.pop(context);
                            widget.appContacts.add(
                              PeopleModel(
                                name: contact.structuredName!.givenName,
                                imageUrl: "",
                                email:
                                    contact.emails.isNotEmpty
                                        ? contact.emails
                                            .map((e) => e.address)
                                            .toList()
                                        : [],
                                phone:
                                    contact.phones.isNotEmpty
                                        ? contact.phones
                                            .map((e) => e.number)
                                            .toList()
                                        : [],
                              ),
                            );
                            setState(() {});
                          },
                          trailing: const CupertinoListTileChevron(),
                          leading: CircleAvatar(
                            child: Text(
                              contact.structuredName!.givenName.substring(0, 1),
                            ),
                          ),
                          title: Text(
                            contact.structuredName!.givenName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
        ],
      ),
    );
  }
}

class ContactPickerModalAndroid extends StatefulWidget {
  const ContactPickerModalAndroid({super.key, required this.appContacts});

  final List<PeopleModel> appContacts;

  @override
  State<ContactPickerModalAndroid> createState() =>
      _ContactPickerModalAndroidState();
}

class _ContactPickerModalAndroidState extends State<ContactPickerModalAndroid> {
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
      final uniqueContacts = <Contact>[];
      for (final contact in contacts) {
        if (!uniqueContacts.any(
          (c) =>
              c.structuredName?.givenName ==
                  contact.structuredName?.givenName &&
              ((c.emails.isNotEmpty &&
                      contact.emails.isNotEmpty &&
                      c.emails.first == contact.emails.first) ||
                  (c.phones.isNotEmpty &&
                      contact.phones.isNotEmpty &&
                      c.phones.first == contact.phones.first)),
        )) {
          uniqueContacts.add(contact);
        }
      }
      setState(() {
        allContacts = uniqueContacts;
        filteredContacts = uniqueContacts;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          final contact = filteredContacts[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(contact.structuredName!.givenName.substring(0, 1)),
            ),
            title: Text(contact.structuredName!.givenName),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {},
          );
        },
      ),
    );
  }
}
