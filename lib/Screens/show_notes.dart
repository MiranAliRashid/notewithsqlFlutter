import 'package:flutter/material.dart';
import 'package:note_with_sql/Screens/add_note.dart';
import 'package:note_with_sql/Screens/update_note.dart';
import 'package:note_with_sql/database/dataModel/note_model.dart';
import 'package:note_with_sql/database/note_database.dart';

class ShowNotes extends StatefulWidget {
  ShowNotes({Key? key}) : super(key: key);

  @override
  State<ShowNotes> createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  late List<NoteModel> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NoteDB.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NoteDB.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddNote()),
          );

          refreshNotes();
        },
      ),
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Center(
        child: isLoading ? CircularProgressIndicator() : AllNotes(),
      ),
    );
  }

  Widget AllNotes() {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        // return ListTile(
        //   title: Text(notes[index].note),
        //   subtitle: Text(notes[index].date.toString()),
        // );
        return Container(
          padding: EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(notes[index].note),
                  Text(notes[index].date.toString()),
                ],
              ),
              IconButton(
                icon: Icon(Icons.update),
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UpdateNote(
                      note: notes[index],
                    );
                  })).then((value) => refreshNotes());
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await NoteDB.instance.delete(notes[index].id);

                  refreshNotes();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
