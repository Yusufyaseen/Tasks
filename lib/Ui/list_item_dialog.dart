import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/Models/list_items.dart';
import '../Utilities/DbHelper.dart';
import '../Models/list_items.dart';

class ItemListDialog extends StatefulWidget {
  final ListItem listItem;
  final bool isNew;
  ItemListDialog(this.listItem, this.isNew);

  @override
  _ItemListDialogState createState() =>
      _ItemListDialogState(this.listItem, this.isNew);
}

class _ItemListDialogState extends State<ItemListDialog> {
  DbHelper helper = DbHelper();
  final ListItem listItem1;
  final bool isNew;
  _ItemListDialogState(this.listItem1, this.isNew);
  final txtPriority = TextEditingController();
  final txtName = TextEditingController();
  final txtDesc = TextEditingController();
  void updateItem() async {
    listItem1.priority = int.parse(txtPriority.text);
    listItem1.name = txtName.text;
    listItem1.description = txtDesc.text;
    await helper.updateItem(listItem1);
    Navigator.pop(context);
  }

  void insertItem() async {
    ListItem item = ListItem(0, listItem1.idList, int.parse(txtPriority.text),
        txtName.text, txtDesc.text);

    await helper.insertItem(item);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState

    if (!isNew) {
      txtPriority.text = listItem1.priority.toString();
      txtName.text = listItem1.name.toString();
      txtDesc.text = listItem1.description.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txtPriority.dispose();
    txtName.dispose();
    txtDesc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!isNew)
        ? AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            title: Text('Edit Task'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: txtName,
                    decoration: InputDecoration(hintText: 'Task Name'),
                  ),
                  TextField(
                    controller: txtPriority,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Task Priority'),
                  ),
                  TextField(
                    controller: txtDesc,
                    decoration: InputDecoration(hintText: 'Task Description'),
                  ),
                ],
              ),
            ),
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
                    'Update Task',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: updateItem,
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)))
        : AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            title: Text('Add New Task'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: txtName,
                    decoration: InputDecoration(hintText: 'Add Task Name'),
                  ),
                  TextField(
                    controller: txtPriority,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Add Task Priority'),
                  ),
                  TextField(
                    controller: txtDesc,
                    decoration: InputDecoration(
                        hintText: 'Add a Description For The Task'),
                  ),
                ],
              ),
            ),
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
                    'Add a New Task',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: insertItem,
                ),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)));
  }
}
