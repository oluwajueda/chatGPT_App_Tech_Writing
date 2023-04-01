import 'package:chat_tutorial/API_Services/api_services.dart';
import 'package:chat_tutorial/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chats = [
    {
      "msg": "Hello, can you tell me about yourself?",
      "chatIndex": 0,
    },
    {
      "msg":
          "Hello, I am ChatGPT, a large language model developed by OpenAI. I am here to assist you with any information or questions you may have. How can I help you today?",
      "chatIndex": 1,
    },
    {
      "msg": "What is stateful widget in flutter?",
      "chatIndex": 0,
    },
    {
      "msg":
          "A StatefulWidget is a special type of widget in Flutter that maintains state across multiple builds of the widget. The state is stored in a State object and is accessible through the widget’s build method. This allows the widget to update its state, and thus the UI, whenever the state object changes.",
      "chatIndex": 1,
    },
    {
      "msg": "Okay thanks",
      "chatIndex": 0,
    },
    {
      "msg":
          "You're welcome! Let me know if you have any other questions or if there's anything else I can help you with.",
      "chatIndex": 1,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 9, 9, 1),
      appBar: AppBar(
        title: const Text("ChatGPT"),
        actions: [
          IconButton(
              onPressed: () async {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    backgroundColor: Color.fromRGBO(9, 9, 9, 1),
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "Models",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            Flexible(flex: 2, child: ModelsDropDown())
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
        elevation: 2,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Material(
                      color: chats[index]['chatIndex'] == 0
                          ? Color.fromRGBO(39, 39, 39, 1)
                          : Color.fromRGBO(3, 104, 37, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                chats[index]["msg"].toString(),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ))
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Material(
            color: Color.fromRGBO(60, 60, 60, 1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (value) async {},
                    decoration: InputDecoration.collapsed(
                        hintText: "How can I help you",
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  IconButton(
                      onPressed: () async {
                        try {
                          await ApiServices.getModels();
                        } catch (e) {
                          print(e);
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
