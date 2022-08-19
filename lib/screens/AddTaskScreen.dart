/// Code in AddTaskScreen here is similar to UpdateTaskScreen,
/// However, UpdateTaskScreen recieved data from TaskDetailProvider which previously recieved data from AddTaskScreen(by databaseHelper Class which manages sqflite saving and other operations)
/// IN SUMMARY: AddTaskScreen -> DatabaseHelper -> show list of tasks in HomeScreen
/// In SUMMARY1: databasesHelper -> TaskDetailProvider -> UpdateTaskScreen

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../database/databaseHelper.dart';
import '../database/task.dart';
import '../widgets/globalWidgets.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _initStatus = 'in progress';
  bool _switchStatus = false;
  String _date = '';
  bool colorSwitch = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose;
    _descController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('ADD TASK?',style: TextStyle(fontSize: 30, color: Colors.deepOrangeAccent),),
                  const SizedBox(height: 16,),
                  Center(child: GlobalWidgets.textTile(label: 'Name')),
                  GlobalWidgets.textFormField(controller: _nameController, maxLength: 100, maxLines: 2,),
                  Center(child: GlobalWidgets.textTile(label: 'Desc')),
                  GlobalWidgets.textFormField(controller: _descController),
                  const SizedBox(height: 16,),
                  Center(child: GlobalWidgets.textTile(label: 'Status')),
                  _buildSwitchListTile(),
                  const SizedBox(height: 16,),
                  Center(child: GlobalWidgets.textTile(label: 'Date')),
                  DateTimePicker(
                    type: DateTimePickerType.dateTime,
                    dateMask: 'd MMM, yyyy',
                    initialValue: '',
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    onChanged: (val) {
                      print(val);
                      setState(() {
                        _date = val;
                      });
                    },
                    validator: (val) {
                      print(val);
                      if (val == null || val.isEmpty)  {
                        print(val!.split('-'));
                        return 'Please select date and time';
                      }
                    },
                    onSaved: (val) => print(val),
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                      child: const Text('Add Task'),
                          onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          try {
                            await DatabaseHelper.instance.add(
                              Task(
                                /// task here has id parameter ///
                                  id: Uuid().v1(),
                                  name: _nameController.text,
                                  status: _initStatus,
                                  desc: _descController.text,
                                  date: _date,
                              ),
                            );
                            setState(() {
                              _nameController.clear();
                              _descController.clear();
                            });
                          } catch(e) {
                            print(e.toString());
                            GlobalWidgets.showErrorDialog(error: e.toString(), context: context);
                          } finally {
                            await GlobalWidgets.showToast(msg:'Task Added Successfully!', color: Colors.blue);
                            Navigator.pop(context);
                          }
                        }
                        else{
                          print('ERROR: ADDING TASK ERROR');
                        }
                        if (!isValid)  {
                          await GlobalWidgets.showToast(msg: "Please fill in all required fields.", color: Colors.redAccent);
                        }
                      }),
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: Text('Home')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Extracted Methods/widgets(NOT the GLOBAL one) starts from here downwards
  SwitchListTile _buildSwitchListTile() {
    return SwitchListTile(
                  title: _switchStatus == false
                      ? const Text(
                    'in progress',
                    style: TextStyle(
                        fontSize: 30, color: Colors.deepOrangeAccent),
                  )
                      : const Text(
                    'completed',
                    style: TextStyle(fontSize: 30, color: Colors.green),
                  ),
                  value: _switchStatus,
                  onChanged: (bool value) {
                    setState(() {
                      _switchStatus = value;
                    });
                  },
                  secondary: _switchStatus == false
                      ? const Icon(
                    Icons.lock_clock,
                    size: 40,
                    color: Colors.deepOrangeAccent,
                  )
                      : const Icon(Icons.check, size: 40, color: Colors.green),
                );
  }

}




