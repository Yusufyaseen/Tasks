import 'dart:math';
import 'deleta_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import '../Utilities/DbHelper.dart';
import '../Models/list_items.dart';
import '../Models/shopping_list.dart';
import '../Ui/ItemScreen.dart';
import '../Ui/shopping_list_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final DbHelper helper = DbHelper();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) => DeleteAll());
              setState(() {});
            },
            icon: Icon(Icons.delete_forever_outlined),
          )
        ],
        title: Text("All Tasks"),
      ),
      body: HomeBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) =>
                ShoppingListDialog(ShoppingList(0, '', 0), true),
          );
          setState(() {});
        },
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final DbHelper helper;
  @override
  void initState() {
    // TODO: implement initState
    helper = DbHelper();
    print("Welcome Sir");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print(" Back");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: helper.getLists(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var list = snapshot.data! as List<dynamic>;
          print(list);
          return Container(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (ctx, i) {
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
                    await helper.deleteList(list[i].id);
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
                              "${list[i].name.toString().toUpperCase()} is deleted",
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
                    elevation: 8,
                    child: ListTile(
                      selectedTileColor: Colors.blueAccent,
                      title: Text(
                        '${list[i].name.toString().toUpperCase()}',
                      ),
                      leading: CircleAvatar(
                        child: Text(list[i].priority.toString()),
                      ),
                      trailing: IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                ShoppingListDialog(list[i], false),
                          );
                          setState(() {});
                        },
                      ),
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemScreen(list[i]),
                              ));
                        });
                      },
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
    );
  }
}
