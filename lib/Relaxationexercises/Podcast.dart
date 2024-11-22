import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Podcast extends StatefulWidget {
  const Podcast({super.key});

  @override
  State<Podcast> createState() => _DeepBreathingState();
}

class _DeepBreathingState extends State<Podcast> {
  final List<Map<String, String>> surahData = [
    {
      'audio': 'Mental health for married couples.mp3',
      'image': 'Images/p6.jpeg'
    },
    {
      'audio': 'Mental health and faith education.mp3',
      'image': 'Images/p7.jpeg'
    },
    {
      'audio':
          'Things the first day changed my life and my mental health - start now immediately.mp3',
      'image': 'Images/p8.jpeg'
    },
    {
      'audio': 'Building psychological strength without paper.mp3',
      'image': 'Images/p9.jpeg'
    },
    {
      'audio':
          'Learn the art of psychological calm and you will not become fanatical after today.mp3',
      'image': 'Images/p10.jpg'
    },
    {'audio': 'p11.mp3', 'image': 'Images/p11.jpeg'},
    {
      'audio': 'Arts of psychological stability.mp3',
      'image': 'Images/p12.jpeg'
    },
    {
      'audio': 'How did we become a psychologically fragile generation.mp3',
      'image': 'Images/p13.jpeg'
    },
    {
      'audio':
          'How to be affected by your parents abuse and recover from it.mp3',
      'image': 'Images/p14.jpg'
    },
    {
      'audio': 'How to maintain your psychological stability.mp3',
      'image': 'Images/p15.jpeg'
    },
    {
      'audio': 'How to design your life and live satisfied.mp3',
      'image': 'Images/p16.jpg'
    },
    {
      'audio': 'How to live a long and healthy life.mp3',
      'image': 'Images/p17.jpeg'
    },
    {'audio': 'How to acquire life skills.mp3', 'image': 'Images/p18.jpeg'},
    {'audio': 'How relationships work.mp3', 'image': 'Images/p19.jpeg'},
    {
      'audio': 'Why were mental asylums associated with the insane.mp3',
      'image': 'Images/p20.jpeg'
    },
    {
      'audio': 'What is psychological and mental health.mp3',
      'image': 'Images/p21.jpeg'
    },
    {
      'audio': 'What does a person lose due to psychological trauma.mp3',
      'image': 'Images/p22.jpeg'
    },
    {
      'audio': 'When will I be ready for education.mp3',
      'image': 'Images/p23.jpeg'
    },
    {'audio': 'Are you really depressed.mp3', 'image': 'Images/p24.jpeg'},
    {'audio': 'The importance of mental health.mp3', 'image': 'Images/p1.jpeg'},
    {
      'audio':
          'Mental illnesses, anxiety, depression, obsessive-compulsive disorder.mp3',
      'image': 'Images/p2.jpg'
    },
    {
      'audio': 'Dieting will not eliminate obesity.mp3',
      'image': 'Images/p3.jpeg'
    },
    {
      'audio': 'The real reason behind psychological comfort.mp3',
      'image': 'Images/p4.jpeg'
    },
    {
      'audio': 'Mental health in the work environment.mp3',
      'image': 'Images/p5.jpeg'
    },
    {'audio': 'Do you suffer from anxiety.mp3', 'image': 'Images/p25.jpeg'},
    {
      'audio':
          'Documentary_Mental Health - How do we persevere despite constant stress, pressure, and crises DW Documentary.mp3',
      'image': 'Images/p26.jpeg'
    },
  ];

  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int currentlyPlayingIndex = -1;

  void playAudio(String audioFile, int index) async {
    if (isPlaying && currentlyPlayingIndex == index) {
      await audioPlayer.pause();
      setState(() {
        isPlaying = false;
        currentlyPlayingIndex = -1;
      });
    } else {
      String url = '$audioFile';
      try {
        await audioPlayer.play(AssetSource(url));
        setState(() {
          isPlaying = true;
          currentlyPlayingIndex = index;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في التشغيل: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: surahData.length,
        itemBuilder: (context, index) {
          final surah = surahData[index];
          return GestureDetector(
            onTap: () => playAudio(surah['audio']!, index),
            child: Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(surah['image']!),
                  fit: BoxFit.fill,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 74, left: 60, right: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      isPlaying && currentlyPlayingIndex == index
                          ? Icons.pause_circle
                          : Icons.play_circle,
                      color: const Color.fromARGB(223, 255, 255, 255),
                      size: 34,
                    ),
                    SizedBox(width: 10),
                    if (isPlaying && currentlyPlayingIndex == index)
                      Text(
                        '...جارٍ التشغيل',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
