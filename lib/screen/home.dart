import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> todoList = ["TASKS"];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStorage();
  }

  checkStorage()async{
     final prefs = await SharedPreferences.getInstance();
     setState(() {
       todoList = prefs.getStringList('task')!;
     });
    
    log("data in todoList $todoList");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DoKaam')),
      body: Column(children: [
        //display list items
        ...todoList.map((text) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      setState(() {
                        todoList.remove(text);
                      });
                    },
                    backgroundColor: const Color.fromARGB(255, 83, 8, 2),
                    foregroundColor: Colors.white,
                    icon: Icons.delete_sweep,
                    label: 'Delete',
                  )
                ],
              ),
              child: SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(text),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        })
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  addDataToStorage() async {
    log("inside add data");
    setState(() {
       log("inside add set State");
      todoList.add(controller.text);
    });
    final prefs = await SharedPreferences.getInstance();
     log("inside add Task");
    await prefs.setStringList('task', todoList);
  }

  displayDialog(BuildContext context) {
    controller.clear();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Something to ToDo"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Enter Your Text"),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    addDataToStorage();
                  },
                  child: const Text('Add it')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }
}
