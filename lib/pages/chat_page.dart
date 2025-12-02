import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../services/app_theme.dart';

const String GEMINI_API_KEY = '';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beƒιт AI Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        primaryColor: AppTheme.appBarBg,
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.appBarBg,
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser = ChatUser(id: '1', firstName: 'You');
  final ChatUser _geminiUser = ChatUser(id: '2', firstName: 'Beƒιт AI');

  final List<ChatMessage> _messages = [];
  late GenerativeModel _model;
  late ChatSession _session;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: GEMINI_API_KEY);
    _session = _model.startChat();
  }

  Future<void> getGeminiResponse(ChatMessage message) async {
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    try {
      final content = Content.text(message.text);
      final response = await _session.sendMessage(content);
      final reply = response.text ?? "⚠️ Gemini didn't return a response.";

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _geminiUser,
            createdAt: DateTime.now(),
            text: reply,
          ),
        );
      });
    } catch (e) {
      print('Gemini Error: $e');
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _geminiUser,
            createdAt: DateTime.now(),
            text: '⚠️ Error: ${e.toString()}',
          ),
        );
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('BeFit AI'),
        backgroundColor: AppTheme.cardColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: DashChat(
                  currentUser: _currentUser,
                  onSend: getGeminiResponse,
                  messages: _messages,
                  messageOptions: MessageOptions(
                    currentUserContainerColor: AppTheme.accentColor,
                    containerColor: AppTheme.cardColor,
                    textColor: AppTheme.textColor,
                    currentUserTextColor: Colors.white,
                    borderRadius: 16.0,
                    showTime: true,
                    messagePadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  inputOptions: InputOptions(
                    inputDecoration: InputDecoration(
                      hintText: "Ask me anything...",
                      hintStyle: TextStyle(color: AppTheme.subtextColor),
                      filled: true,
                      fillColor: AppTheme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                          color: AppTheme.dividerColor,
                          width: 0.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                          color: AppTheme.dividerColor,
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                          color: AppTheme.accentColor,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                    inputTextStyle: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 16,
                    ),
                    sendButtonBuilder: (send) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: _isTyping
                                ? AppTheme.subtextColor
                                : AppTheme.accentColor,
                          ),
                          onPressed: _isTyping ? null : send,
                        ),
                      );
                    },
                    alwaysShowSend: true,
                    sendOnEnter: true,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  typingUsers: _isTyping ? [_geminiUser] : [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
