import 'package:flutter/material.dart';
import '../utils/gradient_text.dart';

class ChatBot extends StatelessWidget {
  static const routeName = '/chatbot';
  const ChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple,
                      Colors.deepPurpleAccent,
                    ]),
                // color: Colors.deepPurple,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0, left: 16.0),
                          child: (Text("Feeling Down?",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: (Text("I'm here to keep you company",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 16.0, bottom: 16.0),
                          child: (TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/chat');
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                              ),
                              child: const Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                                child: GradientText(
                                  "Let's talk",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  gradient: LinearGradient(colors: [
                                    Colors.deepPurpleAccent,
                                    Colors.deepPurple,
                                  ]),
                                ),
                              ))),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/icon.png"),
                            fit: BoxFit.cover),
                      ),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
