import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseController {
  //Database Name File
  static const _databaseName = "students.db";

  //Database Version. Change This when the database has been modified (eg. columns added, etc.), these changes must be implemented in the onUpgrade Function
  static const _databaseVersion = 1;

  //Students Table
  static const studTable = 'student_table';

  //Settings Table (for multiple configuration support)

  static const setTable = 'settings_table';

  //Lessons Table

  static const lessTable = 'lesson_table';

  //Exams Table

  static const examTable = 'exam_table';

  //Manoeuvres Table

  static const manTable = 'manoeuvre_table';

  //Categories Table

  static const catTable = 'category_table';

  //Names of Columns, grouped by table
  //Student Columns
  static const columnStudentId = 'student_id';
  static const columnStudentName = 'student_name';
  static const columnStudentRegistrationNumber = 'student_registration_number';
  static const columnStudentRegistrationDate = 'student_registration_date';
  static const columnStudentCategory = 'student_category';

  //Settings Columns
  static const columnSettingsId = 'settings_id';
  static const columnSettingsLanguage = 'settings_lang';
  static const columnSettingsUnits = 'settings_unit';
  static const columnSettingsPowerSave = 'settings_power';
  static const columnSettingsStoragePath = 'settings_stor';
  static const columnSettingsNotifications = 'settings_notif';
  static const columnSettingsScreenTimeout = 'settings_time';
  static const columnSettingsDirty = 'settings_dirty';

  //Lesson Columns
  static const columnLessonId = 'lesson_id';
  static const columnLessonStudentId = 'lesson_studentId';
  static const columnLessonDate = 'lesson_date';
  static const columnLessonHours = 'lesson_hours';
  static const columnLessonDistance = 'lesson_distance';
  static const columnLessonDone = 'lesson_done';
  static const columnLessonManoeuvres = 'lesson_manoeuvres';
  static const columnLessonCategory = 'lesson_category';

  //Exam Columns
  static const columnExamId = 'exam_id';
  static const columnExamStudentId = 'exam_studentId';
  static const columnExamDate = 'exam_date';
  static const columnExamDone = 'exam_done';
  static const columnExamPassed = 'exam_passed';
  static const columnExamCategory = 'exam_category';

  //Manoeuvre Columns
  static const columnManoeuvreId = 'manoeuvre_id';
  static const columnManoeuvreName = 'manoeuvre_name';
  static const columnManoeuvreCategory = 'manoeuvre_category';

  //Category Columns
  static const columnCategoryId = 'category_id';
  static const columnCategoryName = 'category_name';
  static const columnCategoryDescription = 'category_description';

  DatabaseController._privateConstructor();

  static final DatabaseController instance = DatabaseController._privateConstructor();

  //The Database Object we are going to Handle
  static Database? _database;

  //This is the database getter associated with the Handler and the Database Object, it initiates the database if it hasn't been initiated already.
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
      return _database;
    }
  }

  //This Method is Used to Open a new Database whenever a backup import occurs. It is only called in the settings page.
  openNewDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  //This Method is Used to close the previous Database whenever a backup import occurs. It is only called in the settings page.
  closeDatabase() async {
    Database? db = await instance.database;
    _database = null;
    return await db?.close();
  }

  //The Database initializer, it opens a database (or the existing one) on the specified path (in this case,getApplicationDocumentsDirectory())
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  //Whenever the Database is upgraded from an old version, this method has to be changed (see examples below)
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    //if it is an upgrade and not a downgrade
    if (oldVersion < newVersion) {}
  }

  //When the Database is created for the first time, this is what should happen:
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $studTable (
            $columnStudentId INTEGER PRIMARY KEY,
            $columnStudentName TEXT,
            $columnStudentRegistrationNumber INTEGER,
            $columnStudentRegistrationDate REAL,
            $columnStudentCategory TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $setTable (
            $columnSettingsId INTEGER PRIMARY KEY,
            $columnSettingsLanguage TEXT,
            $columnSettingsUnits INTEGER ,
            $columnSettingsPowerSave INTEGER,
            $columnSettingsStoragePath TEXT,
            $columnSettingsNotifications INTEGER,
            $columnSettingsScreenTimeout REAL,
            $columnSettingsDirty INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $lessTable (
            $columnLessonId INTEGER PRIMARY KEY,
            $columnLessonStudentId INTEGER,
            $columnLessonDate REAL,
            $columnLessonHours REAL,
            $columnLessonDistance REAL,
            $columnLessonDone INTEGER,
            $columnLessonManoeuvres TEXT,
            $columnLessonCategory TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $examTable (
            $columnExamId INTEGER PRIMARY KEY,
            $columnExamStudentId INTEGER,
            $columnExamDate REAL,
            $columnExamDone INTEGER,
            $columnExamPassed INTEGER,
            $columnExamCategory TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $manTable (
            $columnManoeuvreId INTEGER PRIMARY KEY,
            $columnManoeuvreName TEXT,
            $columnManoeuvreCategory TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS $catTable (
            $columnCategoryId INTEGER PRIMARY KEY,
            $columnCategoryName TEXT,
            $columnCategoryDescription TEXT
          )
          ''');
  }

  //Inserting a new Student into the Database
  Future<int?> insertStudent(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(studTable, row);
  }

  //Inserting a new Settings Configuration into the Database
  Future<int?> insertSettings(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(setTable, row);
  }

  //Inserting a new Lesson into the Database
  Future<int?> insertLesson(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(lessTable, row);
  }

  //Inserting a new Exam into the Database
  Future<int?> insertExam(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(examTable, row);
  }

  //Inserting a new Manoeuvre into the Database
  Future<int?> insertManoeuvre(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(manTable, row);
  }

  //Inserting a new Category into the Database
  Future<int?> insertCategory(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(catTable, row);
  }

  //Query (return) all Students
  Future<List<Map<String, dynamic>>?> queryAllRowsStudents() async {
    Database? db = await instance.database;
    var result = await db?.query(studTable);
    return result?.toList();
  }

  //Query (return) all Students with a certain Registration Number (ID) (not to be confused with the internal id)
  Future<List<Map<String, dynamic>>?> queryAllStudentsWithId(int id) async {
    Database? db = await instance.database;
    var result = await db?.query(studTable, where: '$columnStudentRegistrationNumber = ?', whereArgs: [id]);
    return result?.toList();
  }

  //Query (return) all Settings Configurations
  Future<List<Map<String, dynamic>>?> queryAllRowsSettings() async {
    Database? db = await instance.database;
    var result = await db?.query(setTable);
    return result?.toList();
  }

  //Query (return) all Lessons associated with a student with id examStudentId
  Future<List<Map<String, dynamic>>?> queryAllLessonsFromStudent(int lessonStudentId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery('SELECT * FROM $lessTable WHERE $columnLessonStudentId = $lessonStudentId');
    return result?.toList();
  }

  //Query (return) all Lessons
  Future<List<Map<String, dynamic>>?> queryAllRowsLessons() async {
    Database? db = await instance.database;
    var result = await db?.query(lessTable);
    return result?.toList();
  }

  //Query (return) all Lessons within 2 dates
  Future<List<Map<String, dynamic>>?> queryAllLessonsBetween(DateTime from, DateTime to) async {
    int fromInt = from.millisecondsSinceEpoch;
    int toInt = to.millisecondsSinceEpoch;
    Database? db = await instance.database;
    var result = await db?.rawQuery('SELECT * FROM $lessTable WHERE $columnLessonDate BETWEEN $fromInt AND $toInt');
    return result?.toList();
  }

  //Query (return) all Exams associated with a student with id examStudentId
  Future<List<Map<String, dynamic>>?> queryAllExamsFromStudent(int examStudentId) async {
    Database? db = await instance.database;
    var result = await db?.rawQuery('SELECT * FROM $examTable WHERE $columnExamStudentId = $examStudentId');
    return result?.toList();
  }

  //Query (return) all Exams
  Future<List<Map<String, dynamic>>?> queryAllRowsExams() async {
    Database? db = await instance.database;
    var result = await db?.query(examTable);
    return result?.toList();
  }

  //Query (return) all Manoeuvres
  Future<List<Map<String, dynamic>>?> queryAllRowsManoeuvres() async {
    Database? db = await instance.database;
    var result = await db?.query(manTable);
    return result?.toList();
  }

  //Query (return) all Categories
  Future<List<Map<String, dynamic>>?> queryAllRowsCategories() async {
    Database? db = await instance.database;
    var result = await db?.query(catTable);
    return result?.toList();
  }

  //Return number of Waypoints
  Future<int?> queryRowCountStudents() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $studTable'));
  }

  //Return number of Settings Configurations
  Future<int?> queryRowCountSettings() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $setTable'));
  }

  //Return number of Tags
  Future<int?> queryRowCountLessons() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $lessTable'));
  }

  //Return number of Exams
  Future<int?> queryRowCountExams() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $examTable'));
  }

  //Return number of Manoeuvres
  Future<int?> queryRowCountManoeuvres() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $manTable'));
  }

  //Return number of Categories
  Future<int?> queryRowCountCategories() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $catTable'));
  }

  //Seed (Populate) the database
  void seed() async {}

  //Update existing Student Object
  Future<int?> updateStudent(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnStudentId];
    return await db?.update(studTable, row, where: '$columnStudentId = ?', whereArgs: [id]);
  }

  //Update existing Settings Configuration Object
  Future<int?> updateSettings(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnSettingsId];
    return await db?.update(setTable, row, where: '$columnSettingsId = ?', whereArgs: [id]);
  }

  //Update existing Lesson Object
  Future<int?> updateLesson(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnLessonId];
    return await db?.update(lessTable, row, where: '$columnLessonId = ?', whereArgs: [id]);
  }

  //Update existing Exam Object
  Future<int?> updateExam(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnExamId];
    return await db?.update(examTable, row, where: '$columnExamId = ?', whereArgs: [id]);
  }

  //Update existing Manoeuvre Object
  Future<int?> updateManoeuvre(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnManoeuvreId];
    return await db?.update(manTable, row, where: '$columnManoeuvreId = ?', whereArgs: [id]);
  }

  //Update existing Category Object
  Future<int?> updateCategory(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnCategoryId];
    return await db?.update(catTable, row, where: '$columnCategoryId = ?', whereArgs: [id]);
  }

  //Delete a Waypoint
  Future<int?> deleteStudent(int id) async {
    Database? db = await instance.database;
    return await db?.delete(studTable, where: '$columnStudentId = ?', whereArgs: [id]);
  }

  //Delete a Settings Configuration
  Future<int?> deleteSettings(int id) async {
    Database? db = await instance.database;
    return await db?.delete(setTable, where: '$columnSettingsId = ?', whereArgs: [id]);
  }

  //Delete a Lesson
  Future<int?> deleteLesson(int id) async {
    Database? db = await instance.database;
    return await db?.delete(lessTable, where: '$columnLessonId = ?', whereArgs: [id]);
  }

  //Delete an Exam
  Future<int?> deleteExam(int id) async {
    Database? db = await instance.database;
    return await db?.delete(examTable, where: '$columnExamId = ?', whereArgs: [id]);
  }

  //Delete a Manoeuvre
  Future<int?> deleteManoeuvre(int id) async {
    Database? db = await instance.database;
    return await db?.delete(manTable, where: '$columnManoeuvreId = ?', whereArgs: [id]);
  }

  //Delete a Category
  Future<int?> deleteCategory(int id) async {
    Database? db = await instance.database;
    return await db?.delete(catTable, where: '$columnCategoryId = ?', whereArgs: [id]);
  }
}
