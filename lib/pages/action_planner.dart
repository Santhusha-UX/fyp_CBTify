// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../db/database_helper.dart';
import '../models/goal.dart';
import '../models/task.dart';
import '../models/habit.dart';

class ActionPlanner extends StatefulWidget {
  const ActionPlanner({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActionPlannerState createState() => _ActionPlannerState();
}

class _ActionPlannerState extends State<ActionPlanner> {
  List<Goal> goals = [];
  List<Task> tasks = [];
  List<Habit> habits = [];
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _habitController = TextEditingController();
  bool isAddingNewGoal = false;
  bool _isCompletionDialogShown = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() async {
    await _loadGoals();
    await _loadTasks();
    await _loadHabits();
  }

  @override
  void dispose() {
    _goalController.dispose();
    _descriptionController.dispose();
    _taskController.dispose();
    _habitController.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    final loadedGoals = await DatabaseHelper.instance.getGoals();
    setState(() => goals = loadedGoals);
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await DatabaseHelper.instance.getTasks();
    setState(() => tasks = loadedTasks);
  }

  Future<void> _loadHabits() async {
    final loadedHabits = await DatabaseHelper.instance.getHabits();
    setState(() => habits = loadedHabits);
  }

  void _addOrEditGoal({Goal? editingGoal}) {
    final isNewGoal = editingGoal == null;
    if (!isNewGoal) {
      _goalController.text = editingGoal.title;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNewGoal ? 'Add New Goal' : 'Edit Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _goalController,
              decoration: const InputDecoration(labelText: 'Goal'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
              _goalController.clear();
              _descriptionController.clear();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              final title = _goalController.text.trim();
              final description = _descriptionController.text.trim();
              if (isNewGoal) {
                setState(() {
                  final newGoal = Goal(
                      title: title,
                      description: description,
                      progress: 0); // Include description
                  DatabaseHelper.instance
                      .createGoal(newGoal)
                      .then((_) => _loadGoals());
                });
              } else {
                setState(() {
                  editingGoal.title = title;
                });
              }
              Navigator.of(context).pop();
              _goalController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _removeGoal(Goal goal) async {
    await DatabaseHelper.instance.deleteGoal(goal.id!);
    _loadGoals(); // Refresh the list
  }

  void _updateProgress(Goal goal, double progress) async {
    // Convert progress to int if your model uses int
    int progressInt = progress.round();

    if (goal.progress < 100 &&
        progressInt >= 100 &&
        !_isCompletionDialogShown) {
      // Assuming _isCompletionDialogShown is a class-level variable
      _isCompletionDialogShown = true;
      _showCompletionDialog(goal);
    }

    // Update the progress in your state and database
    setState(() {
      goal.progress = progressInt;
    });
    await DatabaseHelper.instance.updateGoal(goal);
  }

  void _showCompletionDialog(Goal goal) {
    if (mounted) {
      // Check if the widget is still in the tree
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20)), // Added rounded corners for consistency
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/achievement_unlocked.json',
                  repeat: false), // Adjusted size for better fit
              const SizedBox(height: 20), // Added space for visual separation
              const Text("🎉 Congratulations! 🎉",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                "You have successfully achieved the goal:\n${goal.title}", // Adjusted text for clarity
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color:
                        Colors.white30 // Adjusted color for theme consistency
                    ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'), // Changed text for a more positive tone
              onPressed: () {
                _removeGoal(goal);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      ).then((_) {
        _isCompletionDialogShown =
            false; // Reset the flag when dialog is dismissed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Action Planner",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
        shadowColor: Colors.white54,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMotivationalBanner(),
            _buildGoalSettingSection(),
            _buildToDoListSection(),
            _buildHabitTrackerSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.shade200.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Lottie.asset('assets/animations/wellness_journey.json',
              width: MediaQuery.of(context).size.width * 0.8, repeat: true),
          const Text(
            "Empower Your Wellness Journey",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Embark on a transformative journey with personalized goals, engaging tasks, and consistent habits.",
            style:
                TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSettingSection() {
    
    void addGoal() async {
      if (_goalController.text.trim().isNotEmpty) {
        final newGoal = Goal(
            title: _goalController.text.trim(),
            description: "Default description",
            progress: 0); // Add default description
        await DatabaseHelper.instance.createGoal(newGoal);
        _goalController.clear();
        _loadGoals(); // Refresh the list of goals
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    "Goal Setting",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white70),
                  tooltip:
                      'What are SMART Goals?', // Added tooltip for better UX
                  onPressed: _showSMARTGoalsInfo,
                ),
              ],
            ),
            const Text(
              "Set a SMART goal to enhance your focus and direction.",
              style: TextStyle(color: Colors.white70), // Improved readability
            ),
            const SizedBox(height: 10),
            if (goals.isEmpty || isAddingNewGoal)
              Column(
                children: [
                  TextField(
                    controller: _goalController,
                    decoration: InputDecoration(
                      labelText: "Define a Goal",
                      hintText: "E.g., Learn a new language",
                      hintStyle: const TextStyle(color: Colors.white24),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon:
                          const Icon(Icons.flag, color: Colors.deepPurpleAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed:
                          addGoal, // Call _addGoal to actually add the goal.
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Add New Goal"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ...goals.map((goal) => ListTile(
                  title: Text(goal.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Progress: ${goal.progress.round()}%',
                          style: const TextStyle(color: Colors.white30)),
                      Slider(
                        value: goal.progress.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '${goal.progress.round()}%',
                        onChanged: (value) => _updateProgress(goal, value),
                        activeColor: Colors.deepPurpleAccent,
                        inactiveColor: Colors.white,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[300]),
                      onPressed: () => _removeGoal(goal)),
                  onTap: () => _addOrEditGoal(editingGoal: goal),
                )),
            if (goals.isNotEmpty && !isAddingNewGoal)
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    isAddingNewGoal =
                        true; // Correctly toggles to show the text field for a new goal
                  }),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Add Another Goal"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSMARTGoalsInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)), // Rounded corners
          title: const Text("What are SMART Goals?",
              style: TextStyle(
                  color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                    "SMART is an acronym that represents a framework for creating clear and reachable goals."),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    children: const [
                      TextSpan(
                          text: "• Specific: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(text: "Clear and well-defined.\n\n"),
                      TextSpan(
                          text: "• Measurable: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(text: "Track progress and measure outcome.\n\n"),
                      TextSpan(
                          text: "• Achievable: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(text: "Realistic and attainable.\n\n"),
                      TextSpan(
                          text: "• Relevant: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(
                          text: "Aligns with your broader objectives.\n\n"),
                      TextSpan(
                          text: "• Time-bound: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      TextSpan(text: "Has a deadline."),
                    ],
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600]), // Unified text style
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                    "Utilizing SMART goals enhances focus and increases the chances of achieving your objectives.",
                    textAlign: TextAlign.justify),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _emptyStateMessage(String message, {String? lottieAnimationPath}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (lottieAnimationPath != null)
          Lottie.asset(
            lottieAnimationPath,
            width: 200, // Adjust the size to fit your layout
            height: 200,
            repeat: true,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white38, // A deeper shade for more emphasis
              fontSize: 14, // Slightly larger text for better readability
              fontStyle: FontStyle.italic, // Bold for emphasis
            ),
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget _buildToDoListSection() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "To-Do List",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Organize your tasks and check them off as you complete each one.",
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<Task>>(
              future: DatabaseHelper.instance.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _emptyStateMessage(
                      "Looks like you're all caught up!\nAdd new tasks to get started.",
                      lottieAnimationPath: 'assets/animations/todo.json');
                }

                List<Task> tasks = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    Task task = tasks[index];
                    return ListTile(
                      title: Text(task.title,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        'Due: ${task.dueDate ?? "Not set"} - Priority: ${task.priority}',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (bool? value) async {
                          await DatabaseHelper.instance
                              .updateTask(task.copy(isCompleted: value!));
                          showCongratulatoryMessage(context);
                          setState(() {});
                        },
                        activeColor: Colors.deepPurpleAccent,
                        checkColor: Colors.white,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white30),
                        onPressed: () => _showEditTaskDialog(context, task),
                      ),
                      onTap: () async {
                        // Toggle task completion
                        task.isCompleted = !task.isCompleted;
                        await DatabaseHelper.instance.updateTask(task);
                        setState(() {});
                      },
                      onLongPress: () => _deleteTaskConfirmation(context, task),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                onPressed: () => _showAddTaskDialog(context),
                icon: const Icon(Icons.add),
                label: const Text("Add New Task"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCongratulatoryMessage(BuildContext context) {
    if (mounted) {
      // Check if the widget is still in the tree
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20)), // Added rounded corners for consistency
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/achievement_unlocked.json',
                  repeat: false), // Adjusted size for better fit
              const SizedBox(height: 20), // Added space for visual separation
              const Text("🥳 Awesome! Task Completed 🥳",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  "Great job on completing your task. Keep up the fantastic work!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white30)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'), // Changed text for a more positive tone
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
            ),
          ],
        ),
      );
    }
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dueDateController =
        TextEditingController(); // To display selected date
    DateTime? selectedDueDate; // To store the actual DateTime object
    final priorityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Task Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                TextField(
                  controller: dueDateController,
                  decoration: const InputDecoration(labelText: "Due Date"),
                  readOnly: true, // Make this field read-only
                  onTap: () async {
                    selectedDueDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDueDate != null) {
                      // If a date is selected
                      dueDateController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDueDate!);
                    }
                  },
                ),
                TextField(
                  controller: priorityController,
                  decoration:
                      const InputDecoration(labelText: "Priority (1-5)"),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Task newTask = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  dueDate: dueDateController.text,
                  priority: int.tryParse(priorityController.text) ?? 1,
                  isCompleted: false,
                );
                await DatabaseHelper.instance.createTask(newTask);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the list
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController =
        TextEditingController(text: task.description);
    DateTime? selectedDueDate; // For handling the date picker selection
    final dueDateController =
        TextEditingController(text: task.dueDate); // For displaying the date
    final priorityController =
        TextEditingController(text: task.priority.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Task Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
                TextField(
                  controller: dueDateController,
                  decoration:
                      const InputDecoration(labelText: "Due Date (YYYY-MM-DD)"),
                  readOnly: true, // Prevent manual editing
                  onTap: () async {
                    // Show date picker when the field is tapped
                    selectedDueDate = await showDatePicker(
                      context: context,
                      initialDate: task.dueDate != null
                          ? DateTime.tryParse(task.dueDate!) ?? DateTime.now()
                          : DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDueDate != null) {
                      // Update the text field if a date is selected
                      dueDateController.text =
                          DateFormat('yyyy-MM-dd').format(selectedDueDate!);
                    }
                  },
                ),
                TextField(
                  controller: priorityController,
                  decoration:
                      const InputDecoration(labelText: "Priority (1-5)"),
                  keyboardType: const TextInputType.numberWithOptions(decimal: false),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update task with new values
                task.title = titleController.text;
                task.description = descriptionController.text;
                task.dueDate = dueDateController.text;
                task.priority = int.tryParse(priorityController.text) ?? 1;
                await DatabaseHelper.instance.updateTask(task);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the UI to reflect changes
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTaskConfirmation(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content:
              Text("Are you sure you want to delete this task: ${task.title}?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Dismiss dialog
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the task and refresh the list
                await DatabaseHelper.instance.deleteTask(task.id!);
                Navigator.of(context).pop(); // Dismiss dialog
                setState(() {});
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHabitTrackerSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Habit Tracker",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 10),
            Text(
                "Visualize and maintain daily habits through 21 days for wellness improvement.",
                style: TextStyle(color: Colors.grey[500])),
            const SizedBox(height: 20),
            FutureBuilder<List<Habit>>(
              future: DatabaseHelper.instance.getHabits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.deepPurpleAccent));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _emptyStateMessage(
                      "No habits tracked yet.\nStart building positive habits today!",
                      lottieAnimationPath: 'assets/animations/habit.json');
                }

                List<Habit> habits = snapshot.data!;
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey[700]),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    Habit habit = habits[index];
                    double completionRate =
                        habit.streak / 30.0; // Assuming a 30-day challenge
                    return ListTile(
                      leading: CircularPercentIndicator(
                        radius: 25.0,
                        lineWidth: 4.0,
                        percent: completionRate <= 1.0 ? completionRate : 1.0,
                        center: Icon(
                          habit.isCompletedToday
                              ? Icons.emoji_events_rounded
                              : Icons.emoji_events_rounded,
                          color: habit.isCompletedToday
                              ? Colors.amber.shade700
                              : Colors.white54,
                        ),
                        progressColor: Colors.deepPurpleAccent,
                        backgroundColor: Colors.grey.shade300,
                      ),
                      title: Text(habit.title,
                          style: const TextStyle(color: Colors.white, fontSize: 18)),
                      subtitle: Text("Streak: ${habit.streak} day(s)",
                          style: TextStyle(color: Colors.grey[400])),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white30),
                        onPressed: () => _showEditHabitDialog(context, habit),
                      ),
                      onTap: () => _confirmHabitCompletion(context, habit),
                      onLongPress: () =>
                          _deleteHabitConfirmation(context, habit),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _showAddHabitDialog(context),
                icon: const Icon(Icons.add),
                label: const Text("Add New Habit"),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurpleAccent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmHabitCompletion(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mark Habit as Completed"),
          content: const Text(
              "Celebrate your consistency! Are you marking this habit as completed for today?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                habit.isCompletedToday = true;
                habit.streak++; // Increment streak as habit is completed today
                await DatabaseHelper.instance.updateHabit(habit);
                Navigator.of(context).pop();
                _showSuccessAnimation(context);
                setState(() {});
              },
              child: const Text('Yes, I did it!',
                  style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessAnimation(BuildContext context) {
    if (mounted) {
      // Check if the widget is still in the tree
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20)), // Added rounded corners for consistency
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/achievement_unlocked.json',
                  repeat:
                      false), // Consider using a success or celebration animation
              const SizedBox(height: 20), // Added space for visual separation
              const Text("🎉 Habit Completed! 🎉",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                  "You did an awesome job completing your habit for today. Keep up the amazing work!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white30)),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('OK'), // Changed text for a more positive tone
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
            ),
          ],
        ),
      );
    }
  }

  void _showAddHabitDialog(BuildContext context) {
    final TextEditingController newHabitController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Habit'),
        content: TextField(
          controller: newHabitController,
          decoration: const InputDecoration(hintText: "Enter new habit"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final habitTitle = newHabitController.text.trim();
              if (habitTitle.isNotEmpty) {
                final newHabit = Habit(
                    title: habitTitle, isCompletedToday: false, streak: 0);
                await DatabaseHelper.instance.createHabit(newHabit);
                Navigator.of(context).pop();
                setState(() {});
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditHabitDialog(BuildContext context, Habit habit) {
    final TextEditingController titleController =
        TextEditingController(text: habit.title);
    final TextEditingController streakController =
        TextEditingController(text: habit.streak.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Habit Title"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              habit.title = titleController.text.trim();
              habit.streak =
                  int.tryParse(streakController.text) ?? habit.streak;
              await DatabaseHelper.instance.updateHabit(habit);
              Navigator.of(context).pop();
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteHabitConfirmation(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Habit"),
          content: Text(
              "Are you sure you want to delete the habit: ${habit.title}?"),
          actions: <Widget>[
            // Cancel button to dismiss the dialog without action
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            // Delete button to proceed with deletion
            TextButton(
              onPressed: () async {
                // Perform the deletion from the database
                await DatabaseHelper.instance.deleteHabit(habit.id!);
                // Dismiss the dialog
                Navigator.of(context).pop();
                // Refresh the list to reflect the deletion
                setState(() {});
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
