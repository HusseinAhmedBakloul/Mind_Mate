import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Thoughts extends StatefulWidget {
  const Thoughts({super.key});

  @override
  State<Thoughts> createState() => _ThoughtsState();
}

class _ThoughtsState extends State<Thoughts> {
  List<String> thoughtsList = [];
  List<Widget> thoughtsContainers = [];

  @override
  void initState() {
    super.initState();
    _loadThoughts();
  }

  Future<void> _loadThoughts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      thoughtsList = prefs.getStringList('thoughtsList') ?? [];
      if (thoughtsList.isEmpty) {
        thoughtsList.add('');
      }
      _buildThoughtsContainers();
    });
  }

  Future<void> _saveThoughts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('thoughtsList', thoughtsList);
  }

  void addThoughtContainer() {
    setState(() {
      thoughtsList.add('');
      _buildThoughtsContainers();
    });
    _saveThoughts();
  }

  void _buildThoughtsContainers() {
    thoughtsContainers = thoughtsList.asMap().entries.map((entry) {
      int index = entry.key;
      String thought = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(48, 76, 175, 79),
            border: Border.all(width: 0.2, color: Colors.green),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  initialValue: thought,
                  textDirection: TextDirection.rtl,
                  maxLines: null,
                  style: TextStyle(
                    color: Color(0xff2596be),
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    setState(() {
                      thoughtsList[index] = value;
                    });
                    _saveThoughts();
                  },
                  decoration: InputDecoration(
                    hintText: 'تدوين المشاعر والأفكار التي تمر بها...',
                    hintTextDirection: TextDirection.rtl,
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Color(0xff2596be),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      thoughtsList.removeAt(index);
                      if (thoughtsList.isEmpty) {
                        thoughtsList.add('');
                      }
                      _buildThoughtsContainers();
                    });
                    _saveThoughts();
                  },
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Colors.red,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: addThoughtContainer,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Color.fromARGB(48, 76, 175, 79),
                      border: Border.all(width: 0.2, color: Colors.green),
                    ),
                    child: Icon(
                      CupertinoIcons.plus,
                      color: Color(0xff2596be),
                      size: 28,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: thoughtsContainers,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
