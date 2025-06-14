import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/font_weights.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.event, required this.imageUrl});

  final EventModel event;
  final String imageUrl;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Theme.of(context).colorScheme.scrim,
            leadingWidth: 64.0,
            leading: MaterialButton(
              elevation: 0.0,
              color: Theme.of(context).colorScheme.surface,
              child: const Icon(Icons.arrow_back, size: 24.0),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              MaterialButton(
                minWidth: 64.0,
                height: 56.0,
                elevation: 0.0,
                color: Theme.of(context).colorScheme.surface,
                child: Icon(Icons.alarm, size: 24.0),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            expandedHeight: 280.0,
            pinned: true,
            floating: false,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
              ),
              title: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth / 2,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Text(
                      widget.event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                        fontWeight:
                            Theme.of(context).textTheme.titleMedium!.fontWeight,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.event.description.isNotEmpty)
                    Text(
                      widget.event.description,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeights.regular,
                      ),
                    ),
                  Text(
                    'Meeting Time: ${DateFormat('jm').format(DateTime.parse(widget.event.startDate))} ${widget.event.endDate != null ? ' - ${DateFormat('jm').format(DateTime.parse(widget.event.endDate!))}' : ''}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeights.regular,
                    ),
                  ),
                  Container(
                    height: 164.0,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Container(
                    height: 164.0,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Container(
                    height: 164.0,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Container(
                    height: 164.0,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Container(
                    height: 164.0,
                    margin: const EdgeInsets.only(top: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
