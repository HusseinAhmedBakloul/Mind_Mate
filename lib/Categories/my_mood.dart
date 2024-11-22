import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMood extends StatefulWidget {
  const MyMood({super.key});

  @override
  State<MyMood> createState() => _MyMoodState();
}

class _MyMoodState extends State<MyMood> {
  List<Map<String, dynamic>> moods = [];
  int? activeMoodIndex;
  String lastMoodDate = '';

  String getMoodEmoji(double dailyAverage) {
    if (dailyAverage >= 0.8) {
      return '😅';
    } else if (dailyAverage >= 0.6) {
      return '😊';
    } else if (dailyAverage >= 0.4) {
      return '😐';
    } else if (dailyAverage >= 0.2) {
      return '😔';
    } else {
      return '😡';
    }
  }

  void saveMoodData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> moodList = moods.map((mood) => jsonEncode(mood)).toList();
    await prefs.setStringList('moodData', moodList);
    await prefs.setString(
        'lastMoodDate', DateFormat('yyyy-MM-dd').format(DateTime.now()));
    print('Mood data saved!');

    // Save to Firebase
    saveMoodToFirebase();
  }

  void saveMoodToFirebase() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final String userId = "user_1";

      for (var mood in moods) {
        await firestore
            .collection('moodData')
            .doc(userId)
            .collection('dailyMoods')
            .add({
          'emoji': mood['emoji'],
          'color': mood['color'],
          'height': mood['height'],
          'time': mood['time'],
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        });
      }
      print("Mood data saved to Firebase!");
    } catch (e) {
      print("Error saving mood to Firebase: $e");
    }
  }

  void loadMoodData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? moodList = prefs.getStringList('moodData');
    lastMoodDate = prefs.getString('lastMoodDate') ?? '';

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (currentDate != lastMoodDate) {
      setState(() {
        moods.clear();
      });
      saveMoodData();
    } else if (moodList != null) {
      setState(() {
        moods = moodList
            .map((moodStr) => jsonDecode(moodStr) as Map<String, dynamic>)
            .toList();
      });
    }
  }

  void updateMood(int index, double height, Color color, String emoji) {
    String currentTime = DateFormat('HH:mm').format(DateTime.now());
    setState(() {
      activeMoodIndex = index;
      moods.add({
        'emoji': emoji,
        'color': color.value,
        'height': height,
        'time': currentTime,
      });
    });
    saveMoodData();
  }

  double calculateDailyAverage() {
    if (moods.isEmpty) return 0.0;
    double totalHeight =
        moods.fold(0.0, (sum, mood) => sum + (mood['height'] as double));
    return totalHeight / moods.length;
  }

  @override
  void initState() {
    super.initState();
    loadMoodData();
  }

  @override
  Widget build(BuildContext context) {
    String currentDateTime =
        DateFormat('yyyy-MM-dd   HH:mm').format(DateTime.now());
    double dailyAverage = calculateDailyAverage();
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(48, 76, 175, 79),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            children: [
                              Text(
                                currentDateTime,
                                style: TextStyle(
                                  color: Color(0xff2596be),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 14),
                              Icon(Icons.edit_calendar_sharp,
                                  color: Color(0xff2596be)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Text(
                "🥰 ما هى حالتك المزاجية الآن؟",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'ReemKufiFun',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  moodButton('😅', Colors.green, 0.9, 0),
                  moodButton('😊', Colors.blue, 0.7, 1),
                  moodButton('😐', Colors.yellow, 0.5, 2),
                  moodButton('😔', Colors.orange, 0.3, 3),
                  moodButton('😡', Colors.red, 0.1, 4),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(48, 76, 175, 79),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'مخطط المزاج',
                        style: TextStyle(
                            color: Color(0xff2596be),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'ReemKufiFun'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: moods.length,
                            itemBuilder: (context, index) {
                              final mood = moods[index];
                              return Container(
                                margin: const EdgeInsets.only(right: 25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Container(
                                          height: 180,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          height:
                                              (200 * (mood['height'] as double))
                                                  .toDouble(),
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Color(mood['color']),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Center(
                                            child: Text(
                                              mood['emoji'],
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      mood['time'],
                                      style: TextStyle(
                                          color: Color(0xff2596be),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  saveMoodData();
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(48, 76, 175, 79),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'حفــظ',
                      style: TextStyle(
                          color: Color(0xff2596be),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget moodButton(String emoji, Color color, double height, int index) {
    return GestureDetector(
      onTap: () {
        updateMood(index, height, color, emoji);
      },
      child: Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }
}
