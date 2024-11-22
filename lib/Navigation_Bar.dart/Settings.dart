import 'dart:io';
import 'package:MindMate/Models/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imagePath = prefs.getString('imagePath') ?? '';
    String savedUsername = prefs.getString('username') ?? '';

    setState(() {
      if (imagePath.isNotEmpty) {
        _imageFile = File(imagePath);
      }
      _usernameController.text = savedUsername;
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('imagePath', pickedFile.path);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'الإعــــدادات',
          style: TextStyle(
            color: Color(0xff2596be),
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'ReemKufiFun',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: .5, color: const Color(0xff2596be)),
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                    ),
                    child: _imageFile == null
                        ? const Icon(Icons.person,
                            size: 60, color: Color(0xff2596be))
                        : ClipOval(
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: 150,
                              height: 150,
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: 9,
                    right: 3,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[800] : Colors.white,
                          border: Border.all(
                              width: 1, color: const Color(0xff2596be)),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit,
                            size: 21, color: Color(0xff2596be)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _usernameController,
                onChanged: (value) => _saveUsername(),
                decoration: InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  labelText: 'اسم المستخدم',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[700] : Colors.white,
                  labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: isDarkMode ? Colors.white : Colors.black),
            ),
            SwitchListTile(
              title: Text('الوضع الليلي'),
              value: themeProvider.isDarkMode,
              onChanged: (bool value) {
                themeProvider.toggleTheme();
              },
              activeColor: Color(0xff2596be),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Color(0xff2596be),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
