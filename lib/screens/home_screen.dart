import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/time_entry_card.dart';
import '../widgets/project_summary_card.dart';
import 'add_time_entry_screen.dart';
import 'project_task_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectTaskManagementScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project summaries
                const Text(
                  'Projects Overview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (provider.projects.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          'No projects yet. Add some projects to get started!'),
                    ),
                  )
                else
                  ...provider.projects.map((project) => ProjectSummaryCard(
                        project: project,
                        totalTime: provider.getTotalTimeForProject(project.id),
                        entryCount: provider
                            .getTimeEntriesForProject(project.id)
                            .length,
                      )),

                const SizedBox(height: 24),

                // Recent time entries
                const Text(
                  'Recent Time Entries',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (provider.timeEntries.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          'No time entries yet. Start tracking your time!'),
                    ),
                  )
                else
                  ...provider.timeEntries.reversed.take(10).map((entry) {
                    final project = provider.getProjectById(entry.projectId);
                    final task = provider.getTaskById(entry.taskId);
                    return TimeEntryCard(
                      timeEntry: entry,
                      projectName: project?.name ?? 'Unknown Project',
                      taskName: task?.name ?? 'Unknown Task',
                      onDelete: () => provider.deleteTimeEntry(entry.id),
                    );
                  }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTimeEntryScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue[600],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
