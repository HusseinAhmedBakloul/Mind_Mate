import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Koran extends StatefulWidget {
  const Koran({super.key});

  @override
  State<Koran> createState() => _KoranState();
}

class _KoranState extends State<Koran> {
  final List<Map<String, String>> surahData = [
    {'title': 'الفاتحة', 'audio': '001.mp3'},
    {'title': 'البقرة', 'audio': '002.mp3'},
    {'title': 'آل عمران', 'audio': '003.mp3'},
    {'title': 'النساء', 'audio': '004.mp3'},
    {'title': 'المائدة', 'audio': '005.mp3'},
    {'title': 'الأنعام', 'audio': '006.mp3'},
    {'title': 'الأعراف', 'audio': '007.mp3'},
    {'title': 'الأنفال', 'audio': '008.mp3'},
    {'title': 'التوبة', 'audio': '009.mp3'},
    {'title': 'يونس', 'audio': '010.mp3'},
    {'title': 'هود', 'audio': '011.mp3'},
    {'title': 'يوسف', 'audio': '012.mp3'},
    {'title': 'الرعد', 'audio': '013.mp3'},
    {'title': 'إبراهيم', 'audio': '014.mp3'},
    {'title': 'الحجر', 'audio': '015.mp3'},
    {'title': 'النحل', 'audio': '016.mp3'},
    {'title': 'الإسراء', 'audio': '017.mp3'},
    {'title': 'الكهف', 'audio': '018.mp3'},
    {'title': 'مريم', 'audio': '019.mp3'},
    {'title': 'طه', 'audio': '020.mp3'},
    {'title': 'الأنبياء', 'audio': '021.mp3'},
    {'title': 'الحج', 'audio': '022.mp3'},
    {'title': 'المؤمنون', 'audio': '023.mp3'},
    {'title': 'النور', 'audio': '024.mp3'},
    {'title': 'الفرقان', 'audio': '025.mp3'},
    {'title': 'الشعراء', 'audio': '026.mp3'},
    {'title': 'النمل', 'audio': '027.mp3'},
    {'title': 'القصص', 'audio': '028.mp3'},
    {'title': 'العنكبوت', 'audio': '029.mp3'},
    {'title': 'الروم', 'audio': '030.mp3'},
    {'title': 'لقمان', 'audio': '031.mp3'},
    {'title': 'السجدة', 'audio': '032.mp3'},
    {'title': 'الأحزاب', 'audio': '033.mp3'},
    {'title': 'سبأ', 'audio': '034.mp3'},
    {'title': 'فاطر', 'audio': '035.mp3'},
    {'title': 'يس', 'audio': '036.mp3'},
    {'title': 'الصافات', 'audio': '037.mp3'},
    {'title': 'ص', 'audio': '038.mp3'},
    {'title': 'الزمر', 'audio': '039.mp3'},
    {'title': 'غافر', 'audio': '040.mp3'},
    {'title': 'فصلت', 'audio': '041.mp3'},
    {'title': 'الشورى', 'audio': '042.mp3'},
    {'title': 'الزخرف', 'audio': '043.mp3'},
    {'title': 'الدخان', 'audio': '044.mp3'},
    {'title': 'الجاثية', 'audio': '045.mp3'},
    {'title': 'الأحقاف', 'audio': '046.mp3'},
    {'title': 'محمد', 'audio': '047.mp3'},
    {'title': 'الفتح', 'audio': '048.mp3'},
    {'title': 'الحجرات', 'audio': '049.mp3'},
    {'title': 'ق', 'audio': '050.mp3'},
    {'title': 'الذاريات', 'audio': '051.mp3'},
    {'title': 'الطور', 'audio': '052.mp3'},
    {'title': 'النجم', 'audio': '053.mp3'},
    {'title': 'القمر', 'audio': '054.mp3'},
    {'title': 'الرحمن', 'audio': '055.mp3'},
    {'title': 'الواقعة', 'audio': '056.mp3'},
    {'title': 'الحديد', 'audio': '057.mp3'},
    {'title': 'المجادلة', 'audio': '058.mp3'},
    {'title': 'الحشر', 'audio': '059.mp3'},
    {'title': 'الممتحنة', 'audio': '060.mp3'},
    {'title': 'الصف', 'audio': '061.mp3'},
    {'title': 'الجمعة', 'audio': '062.mp3'},
    {'title': 'المنافقون', 'audio': '063.mp3'},
    {'title': 'التغابن', 'audio': '064.mp3'},
    {'title': 'الطلاق', 'audio': '065.mp3'},
    {'title': 'التحريم', 'audio': '066.mp3'},
    {'title': 'الملك', 'audio': '067.mp3'},
    {'title': 'القلم', 'audio': '068.mp3'},
    {'title': 'الحاقة', 'audio': '069.mp3'},
    {'title': 'المعارج', 'audio': '070.mp3'},
    {'title': 'نوح', 'audio': '071.mp3'},
    {'title': 'الجن', 'audio': '072.mp3'},
    {'title': 'المزمل', 'audio': '073.mp3'},
    {'title': 'المدثر', 'audio': '074.mp3'},
    {'title': 'القيامة', 'audio': '075.mp3'},
    {'title': 'الإنسان', 'audio': '076.mp3'},
    {'title': 'المرسلات', 'audio': '077.mp3'},
    {'title': 'النبأ', 'audio': '078.mp3'},
    {'title': 'النازعات', 'audio': '079.mp3'},
    {'title': 'عبس', 'audio': '080.mp3'},
    {'title': 'التكوير', 'audio': '081.mp3'},
    {'title': 'الانفطار', 'audio': '082.mp3'},
    {'title': 'المطففين', 'audio': '083.mp3'},
    {'title': 'الانشقاق', 'audio': '084.mp3'},
    {'title': 'البروج', 'audio': '085.mp3'},
    {'title': 'الطارق', 'audio': '086.mp3'},
    {'title': 'الأعلى', 'audio': '087.mp3'},
    {'title': 'الغاشية', 'audio': '088.mp3'},
    {'title': 'الفجر', 'audio': '089.mp3'},
    {'title': 'البلد', 'audio': '090.mp3'},
    {'title': 'الشمس', 'audio': '091.mp3'},
    {'title': 'الليل', 'audio': '092.mp3'},
    {'title': 'الضحى', 'audio': '093.mp3'},
    {'title': 'الشرح', 'audio': '094.mp3'},
    {'title': 'التين', 'audio': '095.mp3'},
    {'title': 'العلق', 'audio': '096.mp3'},
    {'title': 'القدر', 'audio': '097.mp3'},
    {'title': 'البينة', 'audio': '098.mp3'},
    {'title': 'الزلزلة', 'audio': '099.mp3'},
    {'title': 'العاديات', 'audio': '100.mp3'},
    {'title': 'القارعة', 'audio': '101.mp3'},
    {'title': 'التكاثر', 'audio': '102.mp3'},
    {'title': 'العصر', 'audio': '103.mp3'},
    {'title': 'الهُنك', 'audio': '104.mp3'},
    {'title': 'الفيل', 'audio': '105.mp3'},
    {'title': 'قريش', 'audio': '106.mp3'},
    {'title': 'الماعون', 'audio': '107.mp3'},
    {'title': 'الكوثر', 'audio': '108.mp3'},
    {'title': 'الكافرون', 'audio': '109.mp3'},
    {'title': 'النصر', 'audio': '110.mp3'},
    {'title': 'المسد', 'audio': '111.mp3'},
    {'title': 'الإخلاص', 'audio': '112.mp3'},
    {'title': 'الفلق', 'audio': '113.mp3'},
    {'title': 'الناس', 'audio': '114.mp3'},
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
              height: 100,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage('Images/maxresdefault.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 54, left: 60, right: 50),
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          surah['title']!,
                          style: const TextStyle(
                            color: Color.fromARGB(223, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            fontFamily: 'Jomhuria',
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
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
