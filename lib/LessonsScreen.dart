import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // For webview to display video links
import 'package:csv/csv.dart'; // For parsing CSV data
import 'package:http/http.dart' as http; // For making HTTP requests


class LessonsScreen extends StatefulWidget {
  final String csvFile;

  LessonsScreen({required this.csvFile});

  @override
  _LessonsScreenState createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<List<dynamic>>? lessonsData;
  List<List<dynamic>>? filteredLessons; // For filtered lessons
  List<bool> selectedItems = [];
  int completedCount = 0;
  bool isSearching = false; // Flag to show/hide search bar
  TextEditingController searchController =
      TextEditingController(); // Controller for search input

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    try {
      String downloadURL = await _storage.ref(widget.csvFile).getDownloadURL();
      final response = await http.get(Uri.parse(downloadURL));

      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(response.body);
      setState(() {
        lessonsData = csvTable;
        filteredLessons = csvTable; // Initially, no filter applied
        selectedItems = List<bool>.filled(csvTable.length - 1, false);
      });
    } catch (e) {
      print("Error fetching lessons: $e");
    }
  }

  // Search functionality to filter lessons
  void _searchLessons(String query) {
    final suggestions = lessonsData!.where((lesson) {
      final content = lesson[1].toString().toLowerCase();
      final input = query.toLowerCase();
      return content.contains(input);
    }).toList();

    setState(() {
      filteredLessons = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Pass data back to the previous screen
            Navigator.pop(context, {
              'completed': completedCount,
              'total': lessonsData!.length - 1
            });
          },
        ),
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: _searchLessons,
              )
            : Text('Lets Learn', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search,
                color: Colors.white),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  filteredLessons =
                      lessonsData; // Reset the filter when closing search
                }
                isSearching = !isSearching; // Toggle search state
              });
            },
          ),
        ],
      ),
      body: filteredLessons == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredLessons!.length - 1, // Skip header row
              itemBuilder: (context, index) {
                var lesson = filteredLessons![index + 1];
                var content = lesson[1];
                var link = lesson[0];

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.blue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Checkbox(
                        value: selectedItems[index],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedItems[index] = value ?? false;
                            completedCount =
                                selectedItems.where((item) => item).length;
                          });
                        },
                        activeColor: Colors.deepOrange,
                        checkColor: Colors.white,
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          content.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_red_eye, color: Colors.white),
                        onPressed: () {
                          _showVideoDialog(context, link.toString().trim());
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showVideoDialog(BuildContext context, String? videoLink) {
    if (videoLink == null) return;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 400,
            child: Column(
              children: [
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(videoLink)),
                    initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
