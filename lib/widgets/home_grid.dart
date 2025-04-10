import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:planora/utilities/font_weights.dart';

class TwoColumnRandomGrid extends StatefulWidget {
  const TwoColumnRandomGrid({super.key});

  @override
  State<TwoColumnRandomGrid> createState() => _TwoColumnRandomGridState();
}

class _TwoColumnRandomGridState extends State<TwoColumnRandomGrid> {
  final double minHeight = 100; // Minimum height for each block

  late double r1;
  late double r2;
  final String hiveBoxName = 'grid_settings';
  final String r1Key = 'grid_r1';
  final String r2Key = 'grid_r2';

  @override
  void initState() {
    super.initState();
    _loadOrGenerateRandomValues();
  }

  Future<void> _loadOrGenerateRandomValues() async {
    final box = await Hive.openBox(hiveBoxName);

    // If we don't have stored values, generate new ones
    if (!box.containsKey(r1Key) || !box.containsKey(r2Key)) {
      final random = Random();
      r1 = random.nextDouble();
      r2 = random.nextDouble();

      // Store the values
      await box.put(r1Key, r1);
      await box.put(r2Key, r2);
    } else {
      // Use the stored values
      r1 = box.get(r1Key);
      r2 = box.get(r2Key);
    }

    // Force a rebuild with the loaded values
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the parent's maximum height
        final double totalHeight = constraints.maxHeight;
        final double verticalSpacing = 16;
        // Calculate the available height for each column after accounting for spacing
        final double availableHeight = totalHeight - verticalSpacing;

        // Reserve the minimum height for the two blocks in a column.
        final double requiredMin = 2 * minHeight;
        assert(
          availableHeight >= requiredMin,
          'Not enough height to allocate the minimum height for both blocks.',
        );

        // Extra height available to distribute based on stored random values.
        final double extra = availableHeight - requiredMin;

        // For Column 1: use the stored random split.
        final double col1Item1 = minHeight + r1 * extra;
        final double col1Item2 = minHeight + (1 - r1) * extra;

        // For Column 2: use the stored random split.
        final double col2Item1 = minHeight + r2 * extra;
        final double col2Item2 = minHeight + (1 - r2) * extra;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Column
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: col1Item1,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Note: For spacing between children inside Column, you can wrap them in a Column with a SizedBox
                        children: [
                          Text(
                            "Meeting\nPreparation",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "15.00 - 15.30",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  Container(
                    height: col1Item2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Attend an\nOnline Course",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "14.00 - 15.00",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            // Second Column
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: col2Item1,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Reading\na Book",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "11.00 - 11.30",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  Container(
                    height: col2Item2,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "View More",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "+3 schedule",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontFamily:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.fontFamily,
                              fontWeight: FontWeights.medium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
