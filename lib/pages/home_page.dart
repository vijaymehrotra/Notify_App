import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/pages/add_new_note.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        centerTitle: true,
      ),
      body: (!notesProvider.isLoading)
          ? SafeArea(
              child: (notesProvider.notes.isNotEmpty)
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                searchQuery = val;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Search",
                            ),
                          ),
                        ),
                        (notesProvider.getFilteredNotes(searchQuery).isNotEmpty)
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: notesProvider
                                    .getFilteredNotes(searchQuery)
                                    .length,
                                itemBuilder: (context, index) {
                                  Note currentNode = notesProvider
                                      .getFilteredNotes(searchQuery)[index];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => AddNewNote(
                                              isUpdate: true,
                                              note: currentNode),
                                        ),
                                      );
                                    },
                                    onLongPress: () {
                                      //delete
                                      notesProvider.deleteNote(currentNode);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text((index + 1).toString()),
                                          Text(
                                            currentNode.title.toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            currentNode.content.toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text("No notes Found"),
                                ),
                              ),
                      ],
                    )
                  : const Center(
                      child: Text("No notes yet"),
                    ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddNewNote(isUpdate: false),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
