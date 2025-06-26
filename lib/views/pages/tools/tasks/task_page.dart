import 'package:flutter/material.dart';
import 'package:planora/models/task_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class TaskPage extends StatelessWidget {
  final TaskModel task;
  const TaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jm().format(task.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(task.name),
        actionsPadding: const EdgeInsets.only(right: 8.0),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyToClipboard(context),
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title section
                      TextField(
                        controller: TextEditingController(text: task.name),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 16),

                      // Notes section
                      TextField(
                        controller: TextEditingController(text: task.notes),
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add details...',
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ],
                  ),
                ),
              ),

              // Footer with creation date
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  'Created: $formattedDate',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAttachmentOptions(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    // Implement clipboard functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Add Image'),
                  onTap: () => _addAttachment(AttachmentType.image),
                ),
                ListTile(
                  leading: const Icon(Icons.audiotrack),
                  title: const Text('Add Audio'),
                  onTap: () => _addAttachment(AttachmentType.audio),
                ),
                ListTile(
                  leading: const Icon(Icons.videocam),
                  title: const Text('Add Video'),
                  onTap: () => _addAttachment(AttachmentType.video),
                ),
              ],
            ),
          ),
    );
  }

  void _addAttachment(AttachmentType type) {
    // Implement attachment logic
  }
}

enum AttachmentType { image, audio, video }
