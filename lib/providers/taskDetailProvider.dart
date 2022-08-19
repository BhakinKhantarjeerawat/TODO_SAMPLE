/// This TaskDetailProvider is used for setting and returning many values needed for UpdateScreen page
/// In summary: This class (TaskDetailProvider) is called in HomeScreen when users tap on a listile,
/// When called, it will set the value in a Provider Class called TaskDetailProvider.
/// In summary1: In this app, The data in TaskDetailProvider is used for showing already saved value in UpdateTaskScreen, for users to edit the already saved values.

import 'package:flutter/material.dart';

class TaskDetailProvider with ChangeNotifier {

  static String _id = 'initialId';
  String get getId {
    return _id;
  }
  setId({required String id}) {
    _id = id;
  }

  static String _name = 'initialName';
  String get getName {
    return _name;
  }
  setName({required String name}) {
    _name = name;
  }

  static String _desc = 'initialDesc';
  String get getDesc {
    return _desc;
  }
  setDesc({required String desc}) {
    _desc = desc;
  }


  /// status set both String and bool value (for SwitchListTile widget)
  static String _status = 'In Progress';

  String get getStatus {
    return _status;
  }

  setStatus({required String status}) {
    _status = status;
  }
  /// ------------------------------------------------------------------------

  static String _date = 'initialDate';
  String get getDate {
    return _date;
  }
  setDate({required String date}) {
    _date = date;
  }

}