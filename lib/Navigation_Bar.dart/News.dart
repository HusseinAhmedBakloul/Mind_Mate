import 'package:MindMate/Models/NewsArticle%20.dart';
import 'package:MindMate/Pages/NewsDetailPage%20.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'dart:convert';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final translator = GoogleTranslator();

  Future<List<NewsArticle>> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=Mental%20health&pageSize=50&page=1&apiKey=f44017c1cb7d4493ac695124ccf93faa'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List articles = data['articles'];
      return articles.map((article) => NewsArticle.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<String> translateText(String text, String targetLang) async {
    var translation = await translator.translate(text, to: targetLang);
    return translation.text;
  }

  Future<List<NewsArticle>> fetchAndTranslateNews() async {
    final newsList = await fetchNews();
    for (var article in newsList) {
      article.title = await translateText(article.title, 'ar');
      article.description = await translateText(article.description, 'ar');
    }
    return newsList;
  }

  Future<void> storeNewsVisitDuration(
      String articleUrl, Duration duration) async {
    final timestamp = Timestamp.now();
    await FirebaseFirestore.instance.collection('news_visits').add({
      'article_url': articleUrl,
      'visit_duration': duration.inSeconds,
      'timestamp': timestamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الأخبـــــار',
          style: TextStyle(
            color: Color(0xff2596be),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'ReemKufiFun',
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<NewsArticle>>(
        future: fetchAndTranslateNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ أثناء جلب الأخبار'));
          } else {
            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () async {
                      final startTime = DateTime.now();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(
                            newsUrl: news.url,
                            onClose: () {
                              final endTime = DateTime.now();
                              final duration = endTime.difference(startTime);
                              storeNewsVisitDuration(news.url, duration);
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 240,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff2596be)),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              news.imageUrl,
                              width: double.infinity,
                              height: 140,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                      'Images/Screenshot 2024-06-28 185545.png'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  news.title.isNotEmpty
                                      ? news.title
                                      : 'عنوان غير متاح',
                                  style: const TextStyle(
                                    color: Color(0xff2596be),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  news.description.isNotEmpty
                                      ? news.description
                                      : 'وصف غير متاح',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
