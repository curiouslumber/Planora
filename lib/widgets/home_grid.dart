import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class TwoColumnRandomGrid extends StatelessWidget {
  final Random random = Random();
  final double minHeight = 100; // Minimum height for each block

  TwoColumnRandomGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Total height for the container (e.g. 39% of screen height)
    final double totalHeight = MediaQuery.of(context).size.height * 0.39;
    // Vertical spacing between the two blocks in a column
    final double verticalSpacing = 16;
    // Available height in each column after subtracting the spacing
    final double availableHeight = totalHeight - verticalSpacing;

    // For each column, reserve the minimum height for 2 blocks.
    final double requiredMin = 2 * minHeight;
    assert(
      availableHeight >= requiredMin,
      'Not enough height to allocate the minimum height for both blocks.',
    );

    // Extra height available to distribute
    final double extra = availableHeight - requiredMin;

    // For Column 1: generate a random split.
    final double r1 = random.nextDouble();
    final double col1Item1 = minHeight + r1 * extra;
    final double col1Item2 = minHeight + (1 - r1) * extra;

    // For Column 2: generate a random split.
    final double r2 = random.nextDouble();
    final double col2Item1 = minHeight + r2 * extra;
    final double col2Item2 = minHeight + (1 - r2) * extra;

    return SizedBox(
      height: totalHeight,
      child: Row(
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
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          "Meeting\nPreparation",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.theme.colorScheme.surface,
                          ),
                        ),
                        Text(
                          "15.00 - 15.30",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: context.theme.colorScheme.surface,
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
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          "Attend an\nOnline Course",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.theme.colorScheme.surface,
                          ),
                        ),
                        Text(
                          "14.00 - 15.00",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: context.theme.colorScheme.surface,
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
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          "Reading\na Book",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.theme.colorScheme.surface,
                          ),
                        ),
                        Text(
                          "11.00 - 11.30",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: context.theme.colorScheme.surface,
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
                    color: context.theme.colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          "View More",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: context.theme.colorScheme.inverseSurface,
                          ),
                        ),
                        Text(
                          "+3 schedule",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: context.theme.colorScheme.inverseSurface,
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
      ),
    );
  }
}
