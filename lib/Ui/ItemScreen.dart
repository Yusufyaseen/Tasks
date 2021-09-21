import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite/Ui/list_item_dialog.dart';
import '../Models/list_items.dart';
import '../Models/shopping_list.dart';
import '../Utilities/DbHelper.dart';
import 'dart:math';

class ItemScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  ItemScreen(this.shoppingList);

  @override
  _ItemScreenState createState() => _ItemScreenState(this.shoppingList);
}

class _ItemScreenState extends State<ItemScreen> {
  final ShoppingList shoppingList;
  _ItemScreenState(this.shoppingList);
  DbHelper helper = DbHelper();

  @override
  Widget build(BuildContext context) {
    print("Hi yusuf");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('${shoppingList.name.toString().toUpperCase()}'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: helper.getItems(shoppingList.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var item = snapshot.data! as List<dynamic>;
            return Container(
              color: Colors.black12,
              child: ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, int i) {
                  return Dismissible(
                    background: Container(
                      height: 500,
                      color: Colors.redAccent,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    key: Key((Random().nextInt(1000) *
                            Random().nextInt(4000) *
                            Random().nextInt(2000))
                        .toString()),
                    onDismissed: (direction) async {
                      await helper.deleteItem(item[i].id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          padding: EdgeInsets.all(10),
                          content: Row(
                            children: [
                              Icon(
                                Icons.delete_forever,
                                size: 30,
                                color: Colors.white,
                              ),
                              Text(
                                "${item[i].name.toString().toUpperCase()} is deleted",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(10),
                      elevation: 4,
                      child: ListTile(
                        title: Text('${item[i].name.toString().toUpperCase()}'),
                        leading: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          child: Text(item[i].priority.toString()),
                        ),
                        subtitle: Text('${item[i].description}'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  ItemListDialog(item[i], false),
                            );
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ItemListDialog(ListItem(0, shoppingList.id, 0, '', ''), true),
          );
          setState(() {});
        },
      ),
    );
  }
}
