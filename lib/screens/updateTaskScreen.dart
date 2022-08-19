import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_hugeman/widgets/globalWidgets.dart';
import '../database/databaseHelper.dart';
import '../database/task.dart';
import '../providers/taskDetailProvider.dart';

class UpdateTaskScreen extends StatefulWidget {
  const UpdateTaskScreen({Key? key}) : super(key: key);

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final TextEditingController _update_nameController = TextEditingController();
  final TextEditingController _update_descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool colorSwitch = false;
  // bool lights = false;

  /// dispose Instantiated Text Editing Controller to return memory after those controllers are not used.
  @override
  void dispose() {
    // TODO: implement dispose
    _update_nameController.dispose;
    _update_descController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskDetailProvider taskDetailProvider = Provider.of<TaskDetailProvider>(context);
    _update_nameController.text = taskDetailProvider.getName;
    _update_descController.text = taskDetailProvider.getDesc;

    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text('UPDATE TASK?', style: TextStyle(fontSize: 30, color: Colors.deepOrangeAccent),),
                  const SizedBox(height: 16,),
                  Center(child: GlobalWidgets.textTile(label: 'Name')),
                  GlobalWidgets.textFormField(controller: _update_nameController, maxLength: 100, maxLines: 2,),
                  Center(child: GlobalWidgets.textTile(label: 'Desc')),
                  GlobalWidgets.textFormField(controller: _update_descController),
                  const SizedBox(height: 16,),
                  Center(child: GlobalWidgets.textTile(label: 'Status')),
                  _buildSwitchListTile(taskDetailProvider),
                  const SizedBox(height: 16,),
                  Center(child: GlobalWidgets.textTile(label: 'Date')),
                  _buildDateTimePicker(taskDetailProvider),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          child: const Text('Update Task'),
                          onPressed: () async {
                            final isValid = _formKey.currentState!.validate();
                            if (isValid) {
                              try {
                                await DatabaseHelper.instance.update(
                                  Task(
                                    /// Status and Date, each has its own widget, so they are better managed by Provider(this app uses ChangeNotifier.)
                                    /// task here has id parameter ///
                                    id: taskDetailProvider.getId,
                                    name: _update_nameController.text,
                                    status: taskDetailProvider.getStatus,
                                    desc: _update_descController.text,
                                    date: taskDetailProvider.getDate,
                                  ),
                                );
                                setState(() {
                                  _update_nameController.clear();
                                  _update_descController.clear();
                                });
                              } catch(e) {
                                print(e.toString());
                                GlobalWidgets.showErrorDialog(error: e.toString(), context: context);
                              } finally {
                                await GlobalWidgets.showToast(msg:'Task Updated Successfully!', color: Colors.blue);
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
    );;
  }

  DateTimePicker _buildDateTimePicker(TaskDetailProvider taskDetailProvider) {
    return DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  dateMask: 'd MMM, yyyy',
                  /// initiate initialValue with already saved date and time from provider(ChangeNotifier)
                  initialValue: taskDetailProvider.getDate,
                      // ?? DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  /// onChanged might not be necessary for this app, but I include it, in case some test are needed.
                  onChanged: (val) {
                    print('on change below');
                    print(val);
                    setState(() {
                      // _update_date = val;
                    });
                  },
                  validator: (val) {
                    /// print lines below are include incase some tests are needed.
                    print('on validator below');
                    print(val);
                    print(val!.split('-'));
                    if (val == null || val.isEmpty) {
                      return 'Please select updated date';
                    }
                  },
                    /// onChanged might not be necessary for this app, but I include it, in case some test are needed.
                    onSaved: (val) => print('onSaved: '+ val!),
                );
  }

  /// Extracted Methods/widgets(NOT the GLOBAL one) starts from here downwards
  SwitchListTile _buildSwitchListTile(TaskDetailProvider taskDetailProvider) {
    return SwitchListTile(
                  title: taskDetailProvider.getStatus == 'in progress' ?
                  const Text('in progress', style: const TextStyle(fontSize: 30, color: Colors.deepOrangeAccent),)
                      : Text('completed', style: const TextStyle(fontSize: 30, color: Colors.green),),
                  value: (taskDetailProvider.getStatus == 'in progress') ? false : (taskDetailProvider.getStatus == 'completed') ? true : false,
                  onChanged: (bool value) {
                    setState(() {
                      /// The reason to set Name and Status here, is to update the already updated value, if they are not set, the buildMetod will recreate the mobile screen and use the saved values (the old ones, rather than the updated ones)
                      taskDetailProvider.setName(name: _update_nameController.text);
                      taskDetailProvider.setDesc(desc: _update_descController.text);
                      taskDetailProvider.setStatus(status: value == false ? 'in progress' : 'completed');
                      // _switchStatus = ! _switchStatus;
                    });
                  },
                  secondary: taskDetailProvider.getStatus == 'in progress'
                      ? const Icon(
                    Icons.lock_clock,
                    size: 40,
                    color: Colors.deepOrangeAccent,
                  )
                      : const Icon(Icons.check, size: 40, color: Colors.green),
                );
  }

}












