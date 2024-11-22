import 'package:MindMate/Categories/Relaxation%20exercises.dart';
import 'package:MindMate/Categories/my_mood.dart';
import 'package:MindMate/ChatBod/ChatBot.dart';
import 'package:MindMate/Navigation_Bar.dart/News.dart';
import 'package:MindMate/Navigation_Bar.dart/Settings.dart';
import 'package:MindMate/Navigation_Bar.dart/StatisticsPage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    StatisticsPage(),
    News(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff2596be),
        unselectedItemColor: Colors.green,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'الإحصائيات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'الأخبار',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادت',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final homePageState = context.findAncestorStateOfType<_HomePageState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'Images/Screenshot_2024-09-21_170359-removebg-preview.png',
                    height: 70,
                    width: 70,
                  ),
                  const Text(
                    'الصحــة العقليــة',
                    style: TextStyle(
                      color: Color(0xff2596be),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ReemKufiFun',
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'المزايــا',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ReemKufiFun',
                ),
              ),
            ),
            const SizedBox(height: 20),
            CarouselSlider(
              options: CarouselOptions(
                height: 230,
                aspectRatio: 16 / 9,
                viewportFraction: .95,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 2),
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                scrollDirection: Axis.horizontal,
              ),
              items: [
                buildCarouselItem(
                    'Images/young-people-emotions_23-2148266763-removebg-preview.png',
                    'تتبع الحالة المزاجية'),
                buildCarouselItem(
                    'Images/cartoon-style-happy-youth-day-post-illustration_721117-860-removebg-preview.png',
                    'الإسترخاء والهدوء'),
                buildCarouselItem(
                    'Images/Screenshot_2024-09-21_183123-removebg-preview (1).png',
                    'التحدث مع الصديق الذكى'),
                buildCarouselItem(
                    'Images/flat-design-go-further-illustration_23-2150085918-removebg-preview.png',
                    'معاك خطوة بخطوة'),
                buildCarouselItem(
                    'Images/Screenshot_2024-09-25_173802-removebg-preview (1).png',
                    'أخبار الصحة النفسية والعقلية'),
                buildCarouselItem(
                    'Images/Screenshot_2024-09-24_192659-removebg-preview.png',
                    'تدوين الأفكار والمشاعر'),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'الفئــات',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'ReemKufiFun',
              ),
            ),
            const SizedBox(height: 20),
            buildCategories(homePageState!),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildCarouselItem(String imagePath, String title) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 2, color: const Color(0xff2596be)),
      ),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 180,
            width: double.infinity,
          ),
          const SizedBox(height: 1),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                title,
                textStyle: const TextStyle(
                  color: Color(0xff2596be),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCategories(_HomePageState homePageState) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: Color(0xff2596be))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyMood()),
                  );
                },
                child: Row(
                  children: [
                    buildCategoryImage(
                      'Images/flat-design-schizophrenia-illustration_23-2149364625-removebg-preview.png',
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'الحالـة المزاجيـة',
                      style: TextStyle(
                        color: Color(0xff2596be),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Divider(height: .1, color: Color(0xff2596be)),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Relaxationexercises(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    buildCategoryImage(
                      'Images/cartoon-style-happy-youth-day-post-illustration_721117-860-removebg-preview.png',
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'الإسترخــاء',
                      style: TextStyle(
                        color: Color(0xff2596be),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Divider(height: .1, color: Color(0xff2596be)),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    buildCategoryImage(
                      'Images/Screenshot_2024-09-21_183123-removebg-preview (1).png',
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'الصديـق الذكـى',
                      style: TextStyle(
                        color: Color(0xff2596be),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryImage(String imagePath) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xff2596be)),
      ),
      child: Image.asset(imagePath),
    );
  }
}
