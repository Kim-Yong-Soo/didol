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
  File? inputImage;
  List<Color> emotionColors = List.filled(7, Colors.white);
  int? image_icon;

  TextEditingController controller = TextEditingController();

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  Future<File?> _getImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 60);
    return File(image!.path);
  }

  int getIndex() {
    int tmp = 0;
    switch (inputEmotion) {
      case "행복":
        tmp = 0;
        break;
      case "슬픔":
        tmp = 1;
        break;
      case "분노":
        tmp = 2;
        break;
      case "놀람":
        tmp = 3;
        break;
      case "공포":
        tmp = 4;
        break;
      case "혐오":
        tmp = 5;
        break;
      case "중립":
        tmp = 6;
        break;
    }
    return tmp;
  }

  @override
  void initState() {
    super.initState();
    image_icon = 0xe048;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      title: const Text("디돌"),
      actions: [
        IconButton(
            onPressed: () {
              // dbHelper?.deleteAllDialogs();
            },
            icon: const Icon(Icons.settings)),
      ],
      headerExpandedHeight: 0.55,
      headerWidget: Expanded(
        child: Container(
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
                  focusedDay: focusedDay,
                  locale: 'ko-KR',
                  headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                      )),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                    });
                  },
                  selectedDayPredicate: (day) {
                    return isSameDay(selectedDay, day);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      fullyStretchable: false,
      backgroundColor: Colors.white,
      appBarColor: Colors.blueAccent,
      body: [
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
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
                maxLines: 4,
                controller: controller,
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
                        _getImage().then((value) {
                          setState(() {
                            if (inputImage != null) {
                              image_icon = 0xe156; // check
                            } else {
                              image_icon = 0xe048; // add_a_photo
                            }
                            inputImage = value;
                          });
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: (storeDialog == null)
                              ? Icon(
                                  IconData(image_icon!,
                                      fontFamily: 'MaterialIcons'),
                                  color: Colors.lightBlueAccent,
                                )
                              : Icon(
                                  IconData(image_icon!,
                                      fontFamily: 'MaterialIcons'),
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
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: emotionColors[0],
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  if (inputEmotion != null) {
                                    emotionColors[getIndex()] = Colors.white;
                                  }
                                  inputEmotion = "행복";
                                  emotionColors[getIndex()] = Colors.blue;
                                });
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
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: emotionColors[1],
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  if (inputEmotion != null) {
                                    emotionColors[getIndex()] = Colors.white;
                                  }
                                  inputEmotion = "슬픔";
                                  emotionColors[getIndex()] = Colors.blue;
                                });
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
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: emotionColors[2],
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  if (inputEmotion != null) {
                                    emotionColors[getIndex()] = Colors.white;
                                  }
                                  inputEmotion = "분노";
                                  emotionColors[getIndex()] = Colors.blue;
                                });
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
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: emotionColors[3],
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  if (inputEmotion != null) {
                                    emotionColors[getIndex()] = Colors.white;
                                  }
                                  inputEmotion = "놀람";
                                  emotionColors[getIndex()] = Colors.blue;
                                });
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
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: emotionColors[4],
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  if (inputEmotion != null) {
                                    emotionColors[getIndex()] = Colors.white;
                                  }
                                  inputEmotion = "공포";
                                  emotionColors[getIndex()] = Colors.blue;
                                });
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
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: emotionColors[5],
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  if (inputEmotion != null) {
                                    emotionColors[getIndex()] = Colors.white;
                                  }
                                  inputEmotion = "혐오";
                                  emotionColors[getIndex()] = Colors.blue;
                                });
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
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: Ink(
                            decoration: BoxDecoration(
                              color: emotionColors[6],
                              border: Border.all(
                                  color: Colors.lightBlueAccent, width: 1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 72,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                setState(() {
                                  if (inputEmotion != null) {
                                    emotionColors[getIndex()] = Colors.white;
                                  }
                                  inputEmotion = "중립";
                                  emotionColors[getIndex()] = Colors.blue;
                                });
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
                height: 48,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    if (inputImage == null ||
                        inputEmotion == null ||
                        inputData == null) {
                      // Logger().d("inputImage:${inputImage}, inputEmotion:${inputEmotion}, inputData:${inputData}");
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: const Text(
                                  "필수 입력 요소가 덜 입력됐습니다.\n다시 입력부탁드립니다.\n(현재 서버와의 연결이 불가합니다.\n 감정도 선택 부탁드립니다.)"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("확인")),
                              ],
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("저장할까요?", style: TextStyle(fontSize: 24),),
                                    Image.file(inputImage!),
                                    Text(DateFormat('yyyy-MM-dd')
                                        .format(selectedDay)),
                                    Text(inputData!),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    leng += 1;
                                    storeDialog = Dialog(
                                        leng,
                                        DateFormat('yyyy-MM-dd')
                                            .format(selectedDay),
                                        inputData,
                                        inputEmotion,
                                        Utility.base64String(
                                            inputImage!.readAsBytesSync()));
                                    Logger().d("$storeDialog");
                                    dbHelper!.createData(storeDialog!);
                                    emotionColors[getIndex()] = Colors.white;
                                    image_icon = 0xe048;
                                    storeDialog = null;
                                    inputEmotion = null;
                                    inputData = "";
                                    inputImage = null;
                                    controller.text = "";
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("확인"),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("취소")),
                              ],
                            );
                          });
                    }
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

class EmotionDays extends StatelessWidget {
  final String emotionText;
  final Future<List<Dialog>?> dialogs;

  const EmotionDays(
      {super.key, required this.emotionText, required this.dialogs});

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
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                    child: Utility
                                                        .imageFromBase64String(
                                                            snapshot
                                                                .data![index]
                                                                .image!)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 2)),
                                                Text(snapshot
                                                    .data![index].date!),
                                                Text(snapshot
                                                    .data![index].content!),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("닫기")),
                                            ],
                                          );
                                        });
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(8),
                                    elevation: 8,
                                    child: GridTile(
                                      footer: GridTileBar(
                                        backgroundColor: Colors.black38,
                                        title: Text(snapshot.data![index].date
                                            .toString()),
                                      ),
                                      child: Center(
                                        child: Utility.imageFromBase64String(
                                            snapshot.data![index].image!),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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

  DateTime? getDateTypeDateTime() {
    return DateTime.tryParse(date!);
  }
}

class DialogForCalendar {
  int? id;
  String? content, emotion, image;

  DialogForCalendar(this.id, this.content, this.emotion, this.image);
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
    Logger().d("getAllDialog : ${maps.length}, ${maps[0]['date'].runtimeType}");

    return List.generate(maps.length, (i) {
      return Dialog(maps[i]['id'], maps[i]['date'], maps[i]['content'],
          maps[i]['emotion'], maps[i]['image']);
    });
  }

  // Read All and return date mainly
  // Future<Map<DateTime, DialogForCalendar>> getMapDateAllDialog() async {
  //   final db = await database;
  //   dbHelper?.deleteAllDialogs();
  //
  //   final List<Map<String, dynamic>> maps = await db.query(tableName);
  //   leng = maps.length;
  //   Logger().d("getAllDialog : ${maps.length}");
  //
  //   Map<DateTime, List<DialogForCalendar>> dialogs = {};
  //
  //   for (int i = 0; i < maps.length; i++) {
  //     dialogs[DateTime.tryParse(maps[i]['date'])!] = DialogForCalendar(maps[i]['id'], maps[i]['content'],
  //         maps[i]['emotion'], maps[i]['image']);
  //   }
  //
  //   return dialogs;
  // }

  Future<List<Dialog>?> getEmotionSeletedDialog(String emotion) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = (await db
        .rawQuery('SELECT * FROM $tableName WHERE emotion=?', [emotion]));
    // Logger().d(
    //     "id: ${maps[0]['id']}, date: ${maps[0]['date']}, content: ${maps[0]['content']}, emotion: ${maps[0]['emotion']} image: ${maps[0]['image']}");

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
