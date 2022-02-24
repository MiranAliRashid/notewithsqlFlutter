import 'package:flutter/material.dart';
import 'package:note_with_sql/database/dataModel/note_model.dart';
import 'package:note_with_sql/database/note_database.dart';

class AddNote extends StatefulWidget {
  AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DateTime? _selected_date;
  TextEditingController _noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'note',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  child: Text(_selected_date == null
                      ? 'No date selected'
                      : '${_selected_date?.year}-${_selected_date?.month}-${_selected_date?.day}'),
                ),
                IconButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2040),
                    ).then((selectedDate) {
                      if (selectedDate == null) {
                        return;
                      } else {
                        setState(() {
                          _selected_date = (selectedDate);
                        });
                      }
                    });
                  },
                  icon: Icon(Icons.date_range_outlined),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  NoteModel newNote = NoteModel(
                    id: 1,
                    note: _noteController.text,
                    date: _selected_date!,
                  );
                  await NoteDB.instance.create(newNote);
                },
                child: Text('Add Note')),
          ],
        ),
      ),
    );
  }
}
