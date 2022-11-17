import 'dart:io';

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApplication()));
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "디돌",
      debugShowCheckedModeBanner: false,
      home: MyStatefulWid(),
    );
  }
}

class MyStatefulWid extends StatelessWidget {
  const MyStatefulWid({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: const Text("디돌"),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
      headerExpandedHeight: 0.5,
      headerWidget: headerWidget(context),
      fullyStretchable: false,
      backgroundColor: Colors.white,
      appBarColor: Colors.blueAccent,
      body: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              side: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {},
                decoration: const InputDecoration(
                    labelText: "오늘 하루 어떠셨나요?", border: InputBorder.none),
                maxLines: 5,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Ink(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.add_a_photo,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      emotionView("행복"),
                      emotionView("슬픔"),
                      emotionView("분노"),
                      emotionView("놀람"),
                      emotionView("공포"),
                      emotionView("혐오"),
                      emotionView("중립"),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(50),
                ),
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.height * 0.05,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                        child: Text(
                      "일기 쓰기",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              ),
            ),
          ),
        ),
        emotionDays("행복"),
        emotionDays("슬픔"),
      ],
    );
  }
}

Widget headerWidget(BuildContext context) {
  return Container(
    color: Colors.blue,
    child: Column(
      children: [
        Card(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 48),
          elevation: 5.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            side: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2021, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            locale: 'ko-KR',
            headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                )),
          ),
        ),
      ],
    ),
  );
}

Material emotionView(String text) {
  return Material(
    type: MaterialType.transparency,
    child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
        width: 72,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: Text(text)),
          ),
        ),
      ),
    ),
  );
}

Widget emotionDays(String emotion) {
  return Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "$emotion했던 하루들",
                style: const TextStyle(fontSize: 16),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SizedBox(
            height: 200,
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 2 / 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12),
                      itemCount: 3,
                      itemBuilder: (context, index) => Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 8,
                            child: GridTile(
                              footer: GridTileBar(
                                backgroundColor: Colors.black38,
                                title: const Text("footer"),
                                subtitle: Text('Item $index'),
                              ),
                              child: Center(
                                child: Text(
                                  index.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          )),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class Dialog {
  final int? id, year, month, day;
  final String? content, emotion;

  Dialog(
      {this.id, this.year, this.month, this.day, this.content, this.emotion});

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'year': this.year,
        'month': this.month,
        'day': this.day,
        'content': this.content,
        'emotion': this.emotion,
      };
}

const String TableName = 'Dialog';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  late Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'MyDialogDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $TableName(
            id INTEGER PRIMARY KEY,
            year INTEGER,
            month INTEGER,
            day INTEGER,
            content TEXT,
            emotion TEXT,
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createData(Dialog dialog) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $TableName(name) VALUES(?)', [
      dialog.year,
      dialog.month,
      dialog.day,
      dialog.content,
      dialog.emotion
    ]);
    return res;
  }

  //Read
  getDialog(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = (await db.query(
      'Dialog',
      where: 'id = ?',
      whereArgs: [id],
    ));

    return maps.isNotEmpty ? maps : null;
  }

  //Read All
  Future<List<Dialog>> getAllDialog() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('Dog');

    return List.generate(maps.length, (i) {
      return Dialog(
          id: maps[i]['id'],
          year: maps[i]['year'],
          month: maps[i]['month'],
          day: maps[i]['day'],
          content: maps[i]['content'],
          emotion: maps[i]['emotion']);
    });
  }

  //Delete
  deleteDialog(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllDialogs() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }
}
