import 'dart:async';

import 'package:flutter/material.dart';

import 'dbHelper.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  bool addTaskState = false;
  bool dataLoaded = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = DbHelper.instance;
  List task = [];
  @override
  void initState() {
    super.initState();
    getTask();
  }

  addTask() async {
    if (formKey.currentState!.validate()) {
      Map<String, String> taskData = {
        'title': titleController.text,
        'description': descController.text
      };
      await db.newTask(taskData).then((value) {
        // ignore: avoid_print
        print('doneeeee');
        setState(() {
          addTaskState = false;
          getTask();
        });
      });
    }
  }

  taskDone(int id) async {
    await db.taskDone(id).then((value) {
      print('deleted task');
      setState(() {
        getTask();
      });
    });
  }

  getTask() async {
    if (addTaskState == false) {
      await db.getAllTask().then((value) {
        setState(() {
          print(value);
          dataLoaded = true;
          titleController.clear();
          descController.clear();
          task = value;
          if (task.isEmpty) {}
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          // ignore: prefer_const_constructors
          title: Center(
            child: const Text('Task To do'),
          ),
        ),
        body: addTaskState
            ? Center(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              label: const Text('title'),
                              hintText: 'add task title',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "title cannot be empty";
                              }
                              // return value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: descController,
                            decoration: InputDecoration(
                              label: const Text('description'),
                              hintText: 'add task description',
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                addTask();
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13))),
                              icon: const Icon(Icons.add_task),
                              label: const Text('Add Task'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: dataLoaded
                        ? ListView.builder(
                            itemCount: task.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: ListTile(
                                  style: ListTileStyle.drawer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  enableFeedback: true,
                                  tileColor: Colors.blue.shade200,
                                  title: Text(task[index]['title'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  subtitle: Text(
                                    task[index]['description'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: IconButton(
                                      onPressed: () {
                                        taskDone(task[index]['id']);
                                      },
                                      icon: const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
        floatingActionButton: addTaskState
            ? null
            : FloatingActionButton.extended(
                label: const Text('add task'),
                elevation: 12,
                onPressed: () {
                  setState(() {
                    addTaskState = true;
                  });

                  // addTask();
                },
                icon: const Icon(Icons.add, color: Colors.white)));
  }
}
