import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [
    ChatMessage(text: "Hello! I am your Smart Health Companion AI. How can I assist you today?", isUser: false),
  ];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    _messages.add(ChatMessage(text: text, isUser: true));
    _isLoading = true;
    notifyListeners();

    // Mock API call to Gemini
    await Future.delayed(const Duration(seconds: 2));
    
    _messages.add(ChatMessage(
      text: "I am a dummy AI response. Please connect the Gemini API in ChatProvider to get real answers. Based on what you said: '\$text', I recommend drinking more water and getting rest.",
      isUser: false,
    ));
    _isLoading = false;
    notifyListeners();
  }
}
