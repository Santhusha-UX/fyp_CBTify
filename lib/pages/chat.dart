// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _chatHistory = [];

  void getAnswer() async {
  const url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyBZ2sMxfBxI8pIe3MkDlUBSzNUQvt61ah4";
  final uri = Uri.parse(url);

  List<Map<String, dynamic>> parts = [];
  for (var i = 0; i < _chatHistory.length; i++) {
    parts.add({"text": _chatHistory[i]["message"]});
  }

  Map<String, dynamic> request = {
    "contents": [
      {
        "parts": parts
      }
    ]
  };

  try {
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse != null &&
          decodedResponse["candidates"] != null &&
          decodedResponse["candidates"].isNotEmpty) {
        final messageText = decodedResponse["candidates"][0]["content"]["parts"][0]["text"];
        setState(() {
          _chatHistory.add({
            "time": DateTime.now(),
            "message": messageText,
            "isSender": false,
          });
        });
      } else {
        print("Response format is not as expected: $decodedResponse");
      }
    } else {
      print("Failed to get a valid response: ${response.statusCode}");
      print("Response Body: ${response.body}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }

  _scrollController.jumpTo(
    _scrollController.position.maxScrollExtent,
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            //get max height
            height: MediaQuery.of(context).size.height - 160,
            child: ListView.builder(
              itemCount: _chatHistory.length,
              shrinkWrap: false,
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (_chatHistory[index]["isSender"]
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: (_chatHistory[index]["isSender"]
                            ? Colors.deepPurple
                            : Colors.white),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(_chatHistory[index]["message"],
                          style: TextStyle(
                              fontSize: 15,
                              color: _chatHistory[index]["isSender"]
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              height: 60,
              width: double.infinity,
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: const GradientBoxBorder(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.deepPurple,
                                Colors.deepPurpleAccent,
                              ]),
                        ),
                        color: Colors.grey.shade800,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          controller: _chatController,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (_chatController.text.isNotEmpty) {
                          _chatHistory.add({
                            "time": DateTime.now(),
                            "message": _chatController.text,
                            "isSender": true,
                          });
                          _chatController.clear();
                        }
                      });
                      _scrollController.jumpTo(
                        _scrollController.position.maxScrollExtent,
                      );

                      getAnswer();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.deepPurpleAccent,
                              Colors.deepPurple,
                            ]),
                        borderRadius:
                            BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 88.0,
                              minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
