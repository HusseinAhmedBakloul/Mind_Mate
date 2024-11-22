import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailPage extends StatefulWidget {
  final String newsUrl;

  NewsDetailPage({required this.newsUrl, required Null Function() onClose});

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String translatedUrl =
        "https://translate.google.com/translate?hl=ar&sl=auto&u=${widget.newsUrl}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'تفاصيل الخبر',
          style: TextStyle(
            color: Color(0xff2596be),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'ReemKufiFun',
          ),
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(translatedUrl)),
      ),
    );
  }
}
