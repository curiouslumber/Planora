import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/views/pages/tools/events.dart';
import 'package:planora/views/pages/tools/notes.dart';
// import 'package:planora/views/pages/tools/tasks/tasks.dart';
import 'package:planora/views/pages/tools/todos/todos.dart';
// import 'package:planora/widgets/common_snackbar.dart';

class ToolItem {
  final String title;
  final IconData? icon;
  final Widget? page;
  final bool isComingSoon;

  const ToolItem({
    required this.title,
    this.icon,
    this.page,
    this.isComingSoon = false,
  });
}

class Tools extends StatelessWidget {
  const Tools({super.key, this.user});

  final UserModel? user;

  List<ToolItem> get _tools => [
        ToolItem(
          title: 'Events',
          icon: Icons.event,
          page: Events(user: user),
        ),
        ToolItem(
          title: 'Todos',
          icon: Icons.task_alt,
          page: const Todos(),
        ),
        ToolItem(
          title: 'Notes',
          icon: Ionicons.book,
          page: const Notes(),
        ),
        const ToolItem(
          title: 'Coming\nSoon!',
          isComingSoon: true,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tools',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final itemSize = (constraints.maxWidth - 48) / 2;
          return GridView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: _tools.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: itemSize,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) => _buildToolItem(context, _tools[index]),
          );
        },
      ),
    );
  }

  Widget _buildToolItem(BuildContext context, ToolItem tool) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isComingSoon = tool.isComingSoon;

    return GestureDetector(
      onTap: () => _handleToolTap(context, tool),
      child: Container(
        decoration: BoxDecoration(
          color: isComingSoon 
              ? colorScheme.surfaceContainer 
              : colorScheme.primary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Center(
          child: isComingSoon
              ? _buildComingSoonContent(theme, tool)
              : _buildToolContent(theme, tool),
        ),
      ),
    );
  }

  Widget _buildToolContent(ThemeData theme, ToolItem tool) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Icon(
          tool.icon,
          color: theme.colorScheme.onPrimary,
          size: 40.0,
        ),
        const SizedBox(height: 16),
        Text(
          tool.title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildComingSoonContent(ThemeData theme, ToolItem tool) {
    return Text(
          tool.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        );
  }

  void _handleToolTap(BuildContext context, ToolItem tool) {
    if (tool.isComingSoon) {
      // CommonSnackbar.showSnackbar(context, 'Coming soon!', Theme.of(context).colorScheme.primary);
    } else if (tool.page != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => tool.page!),
      );
    }
  }
}
