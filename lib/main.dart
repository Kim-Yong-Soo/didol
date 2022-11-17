import 'dart:io';

import 'package:didol/utility.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:table_calendar/table_calendar.dart';

DBHelper? dbHelper;
late int leng;
late String? inputImageString;

void main() {
  dbHelper = DBHelper();
  leng = 0;
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

class MyStatefulWid extends StatefulWidget {
  const MyStatefulWid({super.key});

  @override
  State<StatefulWidget> createState() => MyStateWid();
}

class MyStateWid extends State<MyStatefulWid> {
  Dialog? storeDialog;
  String? inputData = "";
  String? inputEmotion;

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
                onChanged: (value) {
                  inputData = value;
                },
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
                      onTap: () {
                        _getImage();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: (storeDialog == null)
                              ? const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.lightBlueAccent,
                                )
                              : const Icon(
                                  Icons.check,
                                  color: Colors.lightBlueAccent,
                                )),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                inputEmotion = "행복";
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: Text("행복")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                inputEmotion = "슬픔";
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: Text("슬픔")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                inputEmotion = "분노";
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: Text("분노")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                inputEmotion = "놀람";
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: Text("놀람")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                inputEmotion = "공포";
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: Text("공포")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                inputEmotion = "혐오";
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: Text("혐오")),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Ink(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                inputEmotion = "중립";
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: Text("중립")),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                  onTap: () {
                    leng += 1;
                    storeDialog = Dialog(
                        leng,
                        DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        inputData,
                        inputEmotion,
                        inputImageString);
                    Logger().d("$storeDialog");
                    dbHelper!.createData(storeDialog!);
                    storeDialog = null;
                    inputData = "";
                    inputImageString = null;
                    // 첫 입력만 받아들여지는 문제 해결하기
                  },
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
        EmotionDays(
            emotionText: '행복했던',
            dialogs: dbHelper!.getEmotionSeletedDialog("행복")),
        EmotionDays(
            emotionText: '슬펐던',
            dialogs: dbHelper!.getEmotionSeletedDialog("슬픔")),
        EmotionDays(
            emotionText: '분노했던',
            dialogs: dbHelper!.getEmotionSeletedDialog("분노")),
        EmotionDays(
            emotionText: '놀랐던',
            dialogs: dbHelper!.getEmotionSeletedDialog("놀람")),
        EmotionDays(
            emotionText: '공포스러웠던',
            dialogs: dbHelper!.getEmotionSeletedDialog("공포")),
        EmotionDays(
            emotionText: '혐오가 느껴진',
            dialogs: dbHelper!.getEmotionSeletedDialog("혐오")),
        EmotionDays(
            emotionText: '그저그랬던',
            dialogs: dbHelper!.getEmotionSeletedDialog("중립")),
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

class EmotionDays extends StatefulWidget {
  final String emotionText;
  final Future<List<Dialog>?> dialogs;

  const EmotionDays(
      {super.key, required this.emotionText, required this.dialogs});

  @override
  State<StatefulWidget> createState() => _EmotionDays(emotionText, dialogs);
}

class _EmotionDays extends State<EmotionDays> {
  late String emotionText;
  late Future<List<Dialog>?> dialogs;

  _EmotionDays(this.emotionText, this.dialogs);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dialogs,
      builder: (context, snapshot) {
        return (!snapshot.hasData)
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, bottom: 8),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "$emotionText 하루들",
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
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) => Card(
                                        margin: const EdgeInsets.all(8),
                                        elevation: 8,
                                        child: GridTile(
                                          footer: GridTileBar(
                                            backgroundColor: Colors.black38,
                                            title: Text(snapshot
                                                .data![index].date
                                                .toString()),
                                            subtitle: Text(index.toString()),
                                          ),
                                          child: Center(
                                            child:
                                                Utility.imageFromBase64String(
                                                    snapshot
                                                        .data![index].image!),
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
      },
    );
  }
}

Future _getImage() async {
  ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) {
    inputImageString =
        Utility.base64String(File(imgFile!.path).readAsBytesSync());
  });
}

class Dialog {
  int? id;
  String? date, content, emotion, image;

  Dialog(this.id, this.date, this.content, this.emotion, this.image);

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'content': content,
        'emotion': emotion,
        'image': image,
      };

  void setId(int id) {
    this.id = id;
  }

  void setDate(String date) {
    this.date = date;
  }

  void setContent(String content) {
    this.content = content;
  }

  void setEmotion(String emotion) {
    this.emotion = emotion;
  }

  void setImage(String image) {
    this.image = image;
  }
}

const String tableName = 'Dialog';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Dialog.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            date DATETIME,
            content TEXT,
            emotion TEXT,
            image TEXT
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createData(Dialog dialog) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableName (date, content, emotion, image) VALUES (?, ?, ?, ?)',
        [dialog.date, dialog.content, dialog.emotion, dialog.image]);
    Logger().d("res: $res");
    return res;
  }

  //Read
  getDialog(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        (await db.query(tableName, where: 'id = ?', whereArgs: [id]));

    return maps.isNotEmpty ? maps : null;
  }

  //Read All
  Future<List<Dialog>> getAllDialog() async {
    final db = await database;
    dbHelper?.deleteAllDialogs();

    final List<Map<String, dynamic>> maps = await db.query(tableName);
    leng = maps.length;
    Logger().d("getAllDialog : ${maps.length}");

    return List.generate(maps.length, (i) {
      return Dialog(maps[i]['id'], maps[i]['date'], maps[i]['content'],
          maps[i]['emotion'], maps[i]['image']);
    });
  }

  Future<List<Dialog>?> getEmotionSeletedDialog(String emotion) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = (await db
        .rawQuery('SELECT * FROM $tableName WHERE emotion=?', [emotion]));
    Logger().d(
        "id: ${maps[0]['id']}, date: ${maps[0]['date']}, content: ${maps[0]['content']}, emotion: ${maps[0]['emotion']} image: ${maps[0]['image']}");

    if (maps.isEmpty) {
      return null;
    } else {
      return List.generate(maps.length, (i) {
        return Dialog(maps[i]['id'], maps[i]['date'], maps[i]['content'],
            maps[i]['emotion'], maps[i]['image']);
      });
    }
  }

  //Delete
  deleteDialog(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllDialogs() async {
    final db = await database;
    db.rawDelete('DELETE FROM $tableName');
  }
}
