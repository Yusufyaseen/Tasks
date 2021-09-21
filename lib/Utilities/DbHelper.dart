import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/list_items.dart';
import '../Models/shopping_list.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  final int version = 1;
  Database? db;

  Future<Database?> openDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'All_Tasks.db');
    if (db == null) {
      db = await openDatabase(
        path,
        onCreate: (database, version) async {
          await database.execute(
              'CREATE TABLE lists(id INTEGER PRIMARY KEY autoincrement , name TEXT,priority INTEGER)');
          await database.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEY,idList INTEGER,priority INTEGER ,name TEXT, description varchar(100), ' +
                  'FOREIGN KEY(idList)REFERENCES lists(id))');
        },
        version: version,
      );
    }
    return db;
  }

  Future insertList(ShoppingList list) async {
    db = await openDb();
    await db!.rawInsert(
        'INSERT INTO lists(name,priority) VALUES("${list.name}", ${list.priority})');
  }

  Future updateList(ShoppingList list) async {
    db = await openDb();
    await db!.rawUpdate(
        'UPDATE lists SET name = "${list.name}", priority = ${list.priority} where id = ${list.id};');
  }

  Future deleteList(int id) async {
    db = await openDb();
    await db!.rawDelete('delete from items where idList = ?', [id]);
    await db!.rawDelete('delete from lists where id = ?', [id]);
  }

  Future deleteAll() async {
    db = await openDb();
    await db!.rawDelete('delete from items');
    await db!.rawDelete('delete from lists');
  }

  Future<List> getLists() async {
    db = await openDb();
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM lists');
    List lists = maps
        .map((list) => ShoppingList(list['id'], list['name'], list['priority']))
        .toList();
    lists.sort((a, b) => a.priority.compareTo(b.priority));
    return lists;
  }

  Future insertItem(ListItem item) async {
    db = await openDb();

    await db!.rawInsert(
        'INSERT INTO items(idList,priority,name,description) VALUES(${item.idList},${item.priority},"${item.name}","${item.description}")');
  }

  Future updateItem(ListItem item) async {
    db = await openDb();
    await db!.rawUpdate(
        'UPDATE items SET priority = ${item.priority} , name = "${item.name}", description = "${item.description}" where id = ${item.id};');
  }

  Future deleteItem(int id) async {
    db = await openDb();
    await db!.rawDelete('delete from items where id = ?', [id]);
  }

  Future<List> getItems(int? id) async {
    db = await openDb();
    final List<Map<String, dynamic>> maps =
        await db!.rawQuery('SELECT * FROM items where idList = "$id"');
    List lists = maps
        .map((item) => ListItem(item['id'], item['listId'], item['priority'],
            item['name'], item['description']))
        .toList();
    lists.sort((a, b) => a.priority.compareTo(b.priority));
    return lists;
  }

  Future testDb() async {
    db = await openDb();
    await db!
        .execute('INSERT INTO lists(name,priority) VALUES( "sofa Tea", 3)');
    // await db!.execute('INSERT INTO items VALUES(2,100000,"jg","hv","jbvhjv")');
    List lists = await db!.rawQuery('select * from lists');
    // List items = await db!.rawQuery('select * from items');
    print("List is : " + lists.toString());
    // print("Items is : " + items[0].toString());
  }
}
