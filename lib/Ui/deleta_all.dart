import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/Models/list_items.dart';
import '../Utilities/DbHelper.dart';
import '../Models/list_items.dart';

class DeleteAll extends StatefulWidget {
  @override
  _DeleteAllState createState() => _DeleteAllState();
}

class _DeleteAllState extends State<DeleteAll> {
  DbHelper helper = DbHelper();
  void deleteAll() async {
    await helper.deleteAll();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actionsPadding: EdgeInsets.all(10),
        title: Text('Are You Sure You Want To Delete All Group Of Tasks ?'),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(20, 45),
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0)),
                primary: Colors.black87,
                onPrimary: Colors.white,
              ),
              child: Text(
                'Delete All Group Of Tasks',
                style: TextStyle(fontSize: 17),
              ),
              onPressed: deleteAll,
            ),
          )
        ],
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)));
  }
}
