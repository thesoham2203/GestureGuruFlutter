import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'package:csv/csv.dart'; // For parsing CSV data
import 'package:gesture_guru/WelcomeScreen.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:gesture_guru/LessonsScreen.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // List of topics A-Z and 0-9
  final List<String> items = List.generate(26, (index) => String.fromCharCode(65 + index)) + ['0-9'];
  List<String> filteredItems = [];

  // Track the number of completed and total lessons for each topic
  Map<String, int> completedLessons = {};
  Map<String, int> totalLessons = {};

  bool _isSearching = false; // Tracks if search mode is enabled
  String _searchQuery = ''; // Current search query

  @override
  void initState() {
    super.initState();
    _fetchTotalLessons();
    filteredItems = items; // Initialize filteredItems with the complete list
  }

  // Fetch total lessons for each topic from the CSV files
  Future<void> _fetchTotalLessons() async {
    for (String topic in items) {
      String csvFile = topic != '0-9' ? '$topic.csv' : 'Numbers.csv'; // Get CSV filename based on topic
      try {
        String downloadURL = await _storage.ref(csvFile).getDownloadURL();
        final response = await http.get(Uri.parse(downloadURL));

        // Parse CSV to get the number of lessons (subtract 1 for the header row)
        List<List<dynamic>> csvTable = const CsvToListConverter().convert(response.body);
        int totalCount = csvTable.length - 1; // Exclude header

        setState(() {
          totalLessons[topic] = totalCount; // Set the total number of lessons for each topic
        });
      } catch (e) {
        print("Error fetching total lessons for $topic: $e");
        setState(() {
          totalLessons[topic] = 0; // If there's an error, set total lessons to 0
        });
      }
    }
  }

  // Function to handle search query updates
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        filteredItems = items; // Reset the list if the search query is empty
      } else {
        filteredItems = items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
      }
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
          },
        ),
        title: _isSearching
            ? TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _updateSearchQuery(value); // Update search results
          },
        )
            : Text('Tutorial', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          _isSearching
              ? IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchQuery = '';
                filteredItems = items; // Reset search results
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredItems.length, // Use the filtered items for the list count
        itemBuilder: (context, index) {
          String displayText = filteredItems[index];
          String csvFile = displayText != '0-9' ? '$displayText.csv' : 'Numbers.csv';

          int completedCount = completedLessons[displayText] ?? 0;
          int totalCount = totalLessons[displayText] ?? 0;

          return GestureDetector(
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonsScreen(csvFile: csvFile),
                ),
              );

              // Update the completion count based on result from LessonsScreen
              if (result != null) {
                setState(() {
                  completedLessons[displayText] = result['completed'];
                  totalLessons[displayText] = result['total'];
                });
              }
            },
            child: Container(
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
                children: [
                  // Circular box with text
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orangeAccent, Colors.redAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      displayText,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  SizedBox(width: 16), // Spacing between circle and text
                  // Number of videos text
                  Text(
                    'Topics Covered: $completedCount/$totalCount', // Displaying progress
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
