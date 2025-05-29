import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/utils/font_weights.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventObjectiveController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Event")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin * 6,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24.0,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'Event Name',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextField(
                          controller: _eventNameController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 24.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'Event Objective',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextField(
                          controller: _eventObjectiveController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 24.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8.0,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                dateFormat: DateFormat('dd/MM/yyyy'),
                                firstDate: DateTime.now(),
                                value: DateTime.now(),
                                mode: DateTimeFieldPickerMode.date,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'End Date (Optional)',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                value: DateTime.now(),
                                dateFormat: DateFormat('dd/MM/yyyy'),
                                mode: DateTimeFieldPickerMode.date,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8.0,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'Start Time',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                value: DateTime.now(),
                                mode: DateTimeFieldPickerMode.time,
                                initialPickerDateTime: DateTime.now(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'End Time',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                mode: DateTimeFieldPickerMode.time,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'People',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            Chip(label: Text('John Doe')),
                            Chip(label: Text('Jane Doe')),
                            Chip(label: Text('Abel Doe')),
                            Chip(label: Text('Katy Doe')),
                            Chip(label: Text('& 2 more')),
                            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'Meeting Details',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8.0,
                          children: [
                            Chip(label: Text("Create new")),
                            Text("or"),
                            Chip(label: Text("Add Existing")),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        label: Text(
          "Create",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeights.bold,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
