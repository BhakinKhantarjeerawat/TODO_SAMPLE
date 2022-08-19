
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_hugeman/providers/taskDetailProvider.dart';
import 'package:to_do_hugeman/screens/AddTaskScreen.dart';
import 'package:uuid/uuid.dart';
import '../database/databaseHelper.dart';
import '../database/task.dart';

import 'updateTaskScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

enum SortBy {
byName, byStatus, byDate
}

enum FilterBy {
  byName, byDesc
}

class HomeScreen extends StatefulWidget  {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var uuid = Uuid();

  String? selectedId;
  String sortBy = 'date';

  /// for searching
  String filterBy = 'name';
  String searchText = '';
  final _searchController = TextEditingController();

  String status = 'in progress';
  bool switchStatus = false;
  bool colorSwitch = true;
  String date = '';

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dtbHelperProvider = Provider.of<DatabaseHelper>(context);
    TaskDetailProvider taskDetailProvider = Provider.of<TaskDetailProvider>(context);

    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.share,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.lightBlueAccent,
        // closeManually: ,
        children: [
          SpeedDialChild(
            // child: Icon(Icons.mail),
            backgroundColor: Colors.blue,
            label: 'Filter By Name',
            onTap: () {
              setState(() {
                filterBy = 'name';
              });
              },
          ),
          SpeedDialChild(
            // child: Icon(Icons.copy),
            backgroundColor: Colors.red,
            label: 'Filter By Desc',
            onTap: () {
              setState(() {
                filterBy = 'desc';
              });
              },
          ),
          SpeedDialChild(
            // child: Icon(Icons.copy),
            backgroundColor: Colors.red,
            label: 'Sort By Name',
            onTap: () {
              setState(() {
                sortBy = 'name';
              });
            },
          ),
          SpeedDialChild(
            // child: Icon(Icons.copy),
            backgroundColor: Colors.red,
            label: 'Sort By status',
            onTap: () {
              setState(() {
                sortBy = 'status';
              });
            },
          ),
          SpeedDialChild(
            // child: Icon(Icons.copy),
            backgroundColor: Colors.red,
            label: 'Sort By time',
            onTap: () {
              setState(() {
                sortBy = 'date';
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[100],
          // leading: Text('ddd'),
          title: TextField(
            onChanged: (value) {
              print(value);
              setState(() {
                searchText = value;
              });
            },
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Type HERE to search, swipe left/right for actions',
              filled: true,
              fillColor: Colors.white,
              enabledBorder:  UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),),
        ),
        body: Center(
          child: FutureBuilder<List<Task>>(
              future:dtbHelperProvider.getTasks(sortBy: sortBy, filterBy: filterBy, searchText: searchText ),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Task>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading...'));
                }
                return snapshot.data!.isEmpty
                    ? const Center(child: Text('No Tasks Found'))
                    : ListView(
                  children: snapshot.data!.map((task) {
                    return Center(
                      child: Card(
                        color: selectedId == task.id
                            ? Colors.white70
                            : Colors.white,
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actions: [
                            IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  setState(() async {
                                    await DatabaseHelper.instance.remove(task.id!);
                                  });
                                } ),
                          ],
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Update',
                              color: Colors.blue,
                              icon: Icons.upgrade,
                              onTap: () {
                                setState(() {
                                  /// TaskDetailProvider
                                  taskDetailProvider.setId(id: task.id!);
                                  taskDetailProvider.setName(name: task.name);
                                  taskDetailProvider.setDesc(desc: task.desc);
                                  taskDetailProvider.setStatus(status: task.status);
                                  taskDetailProvider.setDate(date: task.date);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      UpdateTaskScreen()));
                                });
                              },
                            )
                          ],
                          child: ListTile(
                            // leading: task.status == 'in progress' ? Icon(Icons.warning_amber_rounded, color: Colors.deepOrangeAccent, size: 50,) : Icon(Icons.check, color: Colors.green, size: 50,),
                            title: Text(task.name, style: TextStyle(fontSize: 20),),
                            subtitle: Text('Status: '+task.status + '\n' + 'Date: '+task.date+'\n' + 'Details:' + task.desc, style: TextStyle(fontSize: 20, color: task.status == 'in progress' ? Colors.deepOrangeAccent : Colors.green),),
                            // trailing: Text(task.status),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      bottomNavigationBar: Container(
        color: Colors.brown[100],
        child: ElevatedButton(
          child: const Text('Add Task'), onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
        },),
      ),
    );
  }
}










