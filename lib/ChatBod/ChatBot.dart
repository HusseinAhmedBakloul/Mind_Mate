import 'package:MindMate/ChatBod/model.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController promptController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  static const apiKey = "AIzaSyCuuItvyhZrDYIC_XOGTNsH3Z6H6KTHUZ8";
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);
  final List<ModelMessage> messages = [];
  bool isLoading = false;

  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    _endTime = DateTime.now();
    _logSessionTime();
    super.dispose();
  }

  Future<void> _logSessionTime() async {
    final duration = _endTime.difference(_startTime);
    final sessionTimeInSeconds = duration.inSeconds;

    await FirebaseFirestore.instance.collection('user_sessions').add({
      'start_time': _startTime.toIso8601String(),
      'end_time': _endTime.toIso8601String(),
      'duration_seconds': sessionTimeInSeconds,
    });
  }

  Future<void> sendMessage() async {
    final messageText = promptController.text.trim();

    if (messageText.isEmpty) return;

    setState(() {
      messages.add(ModelMessage(
          isprompt: true, message: messageText, time: DateTime.now()));
      promptController.clear();
    });

    _scrollToBottom();

    setState(() {
      isLoading = true;
    });

    try {
      final responseText = await generateResponse(messageText);
      setState(() {
        messages.add(ModelMessage(
            isprompt: false, message: responseText, time: DateTime.now()));
      });
    } catch (e) {
      setState(() {
        messages.add(ModelMessage(
            isprompt: false,
            message: "عذرًا، حدث خطأ أثناء معالجة طلبك.",
            time: DateTime.now()));
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<String> generateResponse(String userMessage) async {
    final keywords = ["اسمك اي", "ما اسمك", "اخبرني عنك"];

    if (keywords.any((keyword) => userMessage.contains(keyword))) {
      return "اسمي بشاير، كيف أستطيع مساعدتك؟";
    } else {
      final content = [Content.text(userMessage)];
      final response = await model.generateContent(content);
      return response.text ?? 'عذرًا، لم أتمكن من فهم طلبك.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color(0xff2596be), size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '🤍 بشايـــــــر',
          style: TextStyle(
            color: Color(0xff2596be),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'ReemKufiFun',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (isLoading && index == messages.length) {
                  return loadingBubble();
                }
                final message = messages[index];
                return Align(
                  alignment: message.isprompt
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: messageBubble(message),
                );
              },
            ),
          ),
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textDirection: TextDirection.rtl,
              controller: promptController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                hintText: '💚 أهلا! كيف يمكنني مساعدتك اليوم؟',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: sendMessage,
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xff2596be),
              child: Icon(Icons.send, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget messageBubble(ModelMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: message.isprompt ? const Color(0xff2596be) : Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft:
              message.isprompt ? const Radius.circular(20) : Radius.zero,
          bottomRight:
              message.isprompt ? Radius.zero : const Radius.circular(20),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7,
      ),
      child: Text(
        message.message,
        style: TextStyle(
          fontSize: 16,
          color: message.isprompt ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget loadingBubble() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularProgressIndicator(strokeWidth: 2),
        ],
      ),
    );
  }
}
