import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';

class TimeEntryProvider extends ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];
  List<TimeEntry> _timeEntries = [];

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  List<TimeEntry> get timeEntries => _timeEntries;

  TimeEntryProvider() {
    _loadData();
  }

  // Load data from local storage
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load projects
    final projectsJson = prefs.getString('projects');
    if (projectsJson != null) {
      final List<dynamic> projectsList = json.decode(projectsJson);
      _projects = projectsList.map((json) => Project.fromJson(json)).toList();
    }

    // Load tasks
    final tasksJson = prefs.getString('tasks');
    if (tasksJson != null) {
      final List<dynamic> tasksList = json.decode(tasksJson);
      _tasks = tasksList.map((json) => Task.fromJson(json)).toList();
    }

    // Load time entries
    final timeEntriesJson = prefs.getString('timeEntries');
    if (timeEntriesJson != null) {
      final List<dynamic> timeEntriesList = json.decode(timeEntriesJson);
      _timeEntries =
          timeEntriesList.map((json) => TimeEntry.fromJson(json)).toList();
    }

    notifyListeners();
  }

  // Save data to local storage
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'projects', json.encode(_projects.map((p) => p.toJson()).toList()));
    await prefs.setString(
        'tasks', json.encode(_tasks.map((t) => t.toJson()).toList()));
    await prefs.setString('timeEntries',
        json.encode(_timeEntries.map((te) => te.toJson()).toList()));
  }

  // Project methods
  void addProject(Project project) {
    _projects.add(project);
    _saveData();
    notifyListeners();
  }

  void deleteProject(String projectId) {
    _projects.removeWhere((p) => p.id == projectId);
    _tasks.removeWhere((t) => t.projectId == projectId);
    _timeEntries.removeWhere((te) => te.projectId == projectId);
    _saveData();
    notifyListeners();
  }

  // Task methods
  void addTask(Task task) {
    _tasks.add(task);
    _saveData();
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    _timeEntries.removeWhere((te) => te.taskId == taskId);
    _saveData();
    notifyListeners();
  }

  List<Task> getTasksForProject(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }

  // Time entry methods
  void addTimeEntry(TimeEntry timeEntry) {
    _timeEntries.add(timeEntry);
    _saveData();
    notifyListeners();
  }

  void deleteTimeEntry(String timeEntryId) {
    _timeEntries.removeWhere((te) => te.id == timeEntryId);
    _saveData();
    notifyListeners();
  }

  List<TimeEntry> getTimeEntriesForProject(String projectId) {
    return _timeEntries.where((te) => te.projectId == projectId).toList();
  }

  Duration getTotalTimeForProject(String projectId) {
    final entries = getTimeEntriesForProject(projectId);
    return entries.fold(
        Duration.zero, (total, entry) => total + entry.duration);
  }

  Project? getProjectById(String projectId) {
    try {
      return _projects.firstWhere((p) => p.id == projectId);
    } catch (e) {
      return null;
    }
  }

  Task? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      return null;
    }
  }
}
