import 'package:flutter/material.dart';

class EventDetailPage extends StatelessWidget {
  final String eventTitle;
  final String eventImageUrl;
  final String eventDescription;
  final DateTime eventDate;
  final String eventLocation;

  const EventDetailPage({
    super.key,
    required this.eventTitle,
    required this.eventImageUrl,
    required this.eventDescription,
    required this.eventDate,
    required this.eventLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // CustomScrollView is used to integrate the SliverAppBar with the scrollable content
      body: CustomScrollView(
        slivers: <Widget>[
          // SliverAppBar defines the collapsing header with an image
          SliverAppBar(
            // The initial height of the app bar when fully expanded
            expandedHeight: 280.0,
            // When true, the app bar remains visible (collapsed) at the top of the screen
            pinned: true,
            // When false, the app bar does not reappear as soon as the user scrolls up.
            // It only reappears when scrolling back to the top.
            floating: false,
            // flexibleSpace is the area that expands and collapses
            flexibleSpace: FlexibleSpaceBar(
              // The title that appears when the app bar is collapsed
              title: Text(
                eventTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Centers the title when the app bar is collapsed
              centerTitle: true,
              // The background content of the flexible space, typically an image
              background: Image.network(
                eventImageUrl,
                fit: BoxFit.cover, // Ensures the image covers the entire space
                // Apply a color filter to darken the image for better text readability
                colorBlendMode: BlendMode.darken,
                color: Colors.black.withOpacity(0.4),
                // Error handling for image loading
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.black54,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Leading widget, typically a back button
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(
                  context,
                ); // Navigates back to the previous screen (homepage)
              },
            ),
            // Actions on the right side of the app bar
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Implement share functionality for the event
                  // Example: Share.share('Check out this event: $eventTitle at $eventLocation!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share button pressed!')),
                  );
                },
              ),
            ],
            // Background color of the app bar when it is collapsed
            backgroundColor: Theme.of(context).primaryColor,
          ),

          // SliverToBoxAdapter allows placing a single non-sliver widget inside CustomScrollView
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Date & Time:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    // Format the date and time
                    '${eventDate.toLocal().day}/${eventDate.toLocal().month}/${eventDate.toLocal().year} at ${eventDate.toLocal().hour.toString().padLeft(2, '0')}:${eventDate.toLocal().minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Location:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    eventLocation,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'About Event:',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    eventDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  // You can add more event-specific details here, such as:
                  // - Speaker list
                  // - Detailed agenda
                  // - Map to location
                  // - FAQs
                  const SizedBox(height: 24.0),
                  Center(
                    // Call to action button, e.g., Register Now
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for registration or RSVP
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registering for event!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Register Now',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // You can add more slivers here if the page content itself needs to be scrollable
          // with other sliver types, e.g., SliverList, SliverGrid, SliverFillRemaining.
        ],
      ),
    );
  }
}
