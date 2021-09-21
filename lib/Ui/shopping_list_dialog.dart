import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Utilities/DbHelper.dart';
import '../Models/shopping_list.dart';

class ShoppingListDialog extends StatefulWidget {
  final ShoppingList shoppingList;
  final bool isNew;
  ShoppingListDialog(this.shoppingList, this.isNew);

  @override
  _ShoppingListDialogState createState() =>
      _ShoppingListDialogState(this.shoppingList, this.isNew);
}

class _ShoppingListDialogState extends State<ShoppingListDialog> {
  DbHelper helper = DbHelper();
  final ShoppingList shoppingList;
  final bool isNew;
  _ShoppingListDialogState(this.shoppingList, this.isNew);
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();
  void updateList() async {
    shoppingList.name = txtName.text;
    shoppingList.priority = int.parse(txtPriority.text);
    await helper.updateList(shoppingList);
    Navigator.pop(context);
  }

  void insertList() async {
    ShoppingList shoppingList =
        ShoppingList(0, txtName.text, int.parse(txtPriority.text));

    await helper.insertList(shoppingList);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState

    if (!isNew) {
      txtName.text = shoppingList.name.toString();
      txtPriority.text = shoppingList.priority.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    txtName.dispose();
    txtPriority.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!isNew)
        ? AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            title: Text('Edit a group of tasks'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: txtName,
                    decoration: InputDecoration(hintText: 'Group Name'),
                  ),
                  TextField(
                    controller: txtPriority,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Group Priority'),
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
                    'Update a group of tasks',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: updateList,
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)))
        : AlertDialog(
            actionsPadding: EdgeInsets.all(10),
            title: Text('Add a new group of tasks'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: txtName,
                    decoration: InputDecoration(hintText: 'Group Name'),
                  ),
                  TextField(
                    controller: txtPriority,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Group Priority'),
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
                    'Add a new group of tasks',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: insertList,
                ),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)));
  }
}
