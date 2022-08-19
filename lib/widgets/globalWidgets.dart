import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalWidgets {

   static Widget textTile({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(label, style: const TextStyle(fontSize: 20, color: Colors.deepOrangeAccent),),
    );
  }

   static Future showToast({msg, color}) async {
     await Fluttertoast.showToast(
         msg: msg,
         toastLength: Toast.LENGTH_LONG,
         // gravity: ToastGravity.CENTER,
         // timeInSecForIosWeb: 1,
         backgroundColor: color,
         // textColor: Colors.white,
         fontSize: 18.0
     );
   }

   static Widget textFormField({required controller, maxLength=100, maxLines=5}) {
     return TextFormField(
       controller: controller,
       maxLength: maxLength,
       maxLines: maxLines,
       validator: (value) {
         if (value == null || value.isEmpty) {
           return 'Please type something';
         }
         return null;
       },
       decoration: InputDecoration(
         filled: true,
         fillColor: Colors.brown.shade50,
         enabledBorder: const UnderlineInputBorder(
             borderSide: BorderSide(color: Colors.white)),
       ),
     );
   }

   static void showErrorDialog({required String error, required BuildContext context}) {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         title: Row(children: const [
           Icon(Icons.error, color: Colors.deepOrangeAccent),
           SizedBox(width: 10),
           Text('ERROR: ', style: TextStyle(color: Colors.deepOrangeAccent),)
         ],),
         content: Text('$error'),
         actions: [
           TextButton(
             child: const Text('Close'),
             onPressed: () {
               Navigator.canPop(context) ? Navigator.pop(context) : null;
             },
           ),
         ],
       ),);
   }

}