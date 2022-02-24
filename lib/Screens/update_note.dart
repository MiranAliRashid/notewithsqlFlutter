import 'package:flutter/material.dart';
import 'package:note_with_sql/database/dataModel/note_model.dart';
import 'package:note_with_sql/database/note_database.dart';

class UpdateNote extends StatefulWidget {
  UpdateNote({Key? key, this.note}) : super(key: key);
  final NoteModel? note;
  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  @override
  DateTime? _selected_date;
  TextEditingController _noteController = TextEditingController();
  void initState() {
    // TODO: implement initState
    super.initState();
    _selected_date = widget.note!.date;
    _noteController = TextEditingController(text: widget.note!.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('update Note'),
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
                  NoteModel updateNote = NoteModel(
                      id: widget.note!.id,
                      note: _noteController.text,
                      date: _selected_date!);
                  await NoteDB.instance.update(updateNote);
                  Navigator.pop(context);
                },
                child: Text('update Note')),
          ],
        ),
      ),
    );
  }
}
