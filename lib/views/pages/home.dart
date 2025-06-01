import 'package:dotted_border/dotted_border.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const cardRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        actionsPadding: EdgeInsets.only(right: 32),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: GestureDetector(
            onTap: () {},
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Ionicons.notifications_outline,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(
                'Good Morning,',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeights.regular,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Noel Pinto!',
                style: TextStyle(
                  fontFamily:
                      Theme.of(context).textTheme.headlineLarge!.fontFamily,
                  fontWeight: FontWeights.semiBold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 4),
              height: MediaQuery.of(context).size.height * 0.22,
              padding: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Excellent! Your today’s plan is almost done',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeights.medium,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 6,
                            strokeAlign: 8,
                            value: 0.8,
                            color: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.4),
                          ),
                          Text(
                            '82%',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeights.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Today\'s Schedule',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeights.semiBold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 100.0,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(8.0),
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                  padding: EdgeInsets.all(16.0),
                  stackFit: StackFit.expand,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(180),
                    ),
                    Text(
                      "Create Event or Schedule a Meeting",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeights.semiBold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 60.0,
              alignment: Alignment.center,
              child: Text(
                'None to show here...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              child: Text(
                'Made with ❤️\nby Noel Pinto',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
