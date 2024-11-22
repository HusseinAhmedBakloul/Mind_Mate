import 'package:MindMate/Relaxationexercises/Koran.dart';
import 'package:MindMate/Relaxationexercises/Podcast.dart';
import 'package:MindMate/Relaxationexercises/Thoughts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Relaxationexercises extends StatefulWidget {
  @override
  _RelaxationexercisesState createState() => _RelaxationexercisesState();
}

class _RelaxationexercisesState extends State<Relaxationexercises> {
  late Widget container;
  late String currentCategory;
  late DateTime startTime;

  @override
  void initState() {
    super.initState();
    currentCategory = 'القـرآن الكريـم';
    container = Koran();
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    _logDuration(currentCategory);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(48, 76, 175, 79),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Color(0xff2596be), size: 22),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 95),
                  child: Text(
                    'الإسترخــاء',
                    style: TextStyle(
                        color: Color(0xff2596be),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: 'ReemKufiFun'),
                  ),
                ),
              ],
            ),
          ),
          CategoriesName(
            updateSelectedCategory: updateSelectedCategory,
            selectedCategory: currentCategory,
          ),
          Expanded(
            child: container,
          ),
        ],
      ),
    );
  }

  void updateSelectedCategory(String category) {
    if (category != currentCategory) {
      _logDuration(currentCategory);
      setState(() {
        currentCategory = category;
        startTime = DateTime.now();
        if (category == 'القـرآن الكريـم') {
          container = Koran();
        } else if (category == 'بودكاســـت') {
          container = const Podcast();
        } else if (category == 'خواطـــر') {
          container = const Thoughts();
        }
      });
    }
  }

  void _logDuration(String category) async {
    final duration = DateTime.now().difference(startTime).inSeconds;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('user_activity').add({
        'category': category,
        'duration': duration,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error logging duration: $e');
    }
  }
}

class CategoriesName extends StatefulWidget {
  final Function(String) updateSelectedCategory;
  final String selectedCategory;

  const CategoriesName(
      {Key? key,
      required this.updateSelectedCategory,
      required this.selectedCategory})
      : super(key: key);

  @override
  _CategoriesNameState createState() => _CategoriesNameState();
}

class _CategoriesNameState extends State<CategoriesName> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
        ),
        child: Row(
          children: [
            categoryItem('القـرآن الكريـم'),
            categoryItem('بودكاســـت'),
            categoryItem('خواطـــر'),
          ],
        ),
      ),
    );
  }

  Widget categoryItem(String category) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        widget.updateSelectedCategory(category);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 10, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.green : const Color.fromARGB(48, 76, 175, 79),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Color(0xff2596be),
          ),
        ),
      ),
    );
  }
}
