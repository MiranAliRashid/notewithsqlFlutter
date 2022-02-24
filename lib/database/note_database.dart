import 'package:note_with_sql/database/dataModel/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDB {
  static final NoteDB instance = NoteDB._init();
  Database? _noteDB;
  NoteDB._init();

  Future<Database> get noteDB async {
    if (_noteDB != null) {
      return _noteDB!;
    }

    _noteDB = await initDB("note.db");
    return _noteDB!;
  }

  Future<Database> initDB(String dbName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);
    return await openDatabase(path, version: 1, onCreate: createnoteDB);
  }

  Future createnoteDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE note(id INTEGER PRIMARY KEY, note TEXT, date DateTime)");
  }

  //create a note
  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.noteDB;

    final id = await db.insert("note", note.toMap());

    return note.copyWith(id: id);
  }

  //read note by id
  Future<NoteModel> read(int id) async {
    final db = await instance.noteDB;
    final note = await db.query("note", where: "id = ?", whereArgs: [id]);
    return NoteModel.fromMap(note.first);
  }

  //read all note
  Future<List<NoteModel>> readAllNotes() async {
    final db = await instance.noteDB;
    final notes = await db.query("note");
    return notes.map((note) => NoteModel.fromMap(note)).toList();
  }

  //update note
  Future<NoteModel> update(NoteModel note) async {
    final db = await instance.noteDB;
    await db
        .update("note", note.toMap(), where: "id = ?", whereArgs: [note.id]);
    return note;
  }

  //delete note
  Future<int> delete(int id) async {
    final db = await instance.noteDB;
    return await db.delete("note", where: "id = ?", whereArgs: [id]);
  }

  //close database
  Future close() async {
    final db = await instance.noteDB;
    return db.close();
  }
}
