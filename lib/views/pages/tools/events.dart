import 'package:flutter/material.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/views/pages/tools/events/add_event.dart';
import 'package:planora/views/pages/tools/events/event_page.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
      ),
      body: Center(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          itemCount: 0,
          separatorBuilder:
              (context, index) => Divider(color: Colors.transparent),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventPage()),
                );
              },
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              "https://th.bing.com/th/id/OIP.4eWWTUHB9wIPvudLm1DIcAHaEK?cb=iwp2&rs=1&pid=ImgDetMain",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimary.withAlpha(200),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                                size: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8.0,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Event title - a lot of text",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  "Event description - a lot of description here",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeights.light,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Theme.of(context).colorScheme.onPrimary,
                            indent: 16.0,
                            endIndent: 16.0,
                          ),
                          Flexible(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FittedBox(
                                  child: Text(
                                    "27th May 2025",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    "10:00 am - 2:00 pm",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEvent()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
  