import 'package:chat_tutorial/API_Services/api_services.dart';
import 'package:chat_tutorial/models/chatModel.dart';
import 'package:chat_tutorial/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../providers/getModel_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    _chatScroll = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _chatScroll.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chats = [];
  late ScrollController _chatScroll;
  late FocusNode focusNode;
  void scrollDown() {
    _chatScroll.animateTo(_chatScroll.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);

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
              controller: _chatScroll,
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Material(
                      color: chats[index].chatIndex == 0
                          ? Color.fromRGBO(39, 39, 39, 1)
                          : Color.fromRGBO(3, 104, 37, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: chats[index].chatIndex == 0
                                  ? Text(
                                      chats[index].msg.toString(),
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    )
                                  : DefaultTextStyle(
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                      child: AnimatedTextKit(
                                        isRepeatingAnimation: false,
                                        repeatForever: false,
                                        displayFullTextOnTap: true,
                                        totalRepeatCount: 1,
                                        animatedTexts: [
                                          TyperAnimatedText(
                                            chats[index].msg.toString().trim(),
                                          )
                                        ],
                                      ),
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
                    focusNode: focusNode,
                    controller: textEditingController,
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (value) async {
                      await sendMessageToOpenAi(
                        modelsProvider: modelsProvider,
                      );
                    },
                    decoration: InputDecoration.collapsed(
                        hintText: "How can I help you",
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  IconButton(
                      onPressed: () async {
                        await sendMessageToOpenAi(
                            modelsProvider: modelsProvider);
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

  Future<void> sendMessageToOpenAi({
    required ModelsProvider modelsProvider,
  }) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can't send multiple messages"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String message = textEditingController.text;
      setState(() {
        chats.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      chats.addAll(await ApiServices.sendMessages(
          message: message, modelId: modelsProvider.getCurrentModel));

      setState(() {});
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        scrollDown();
      });
    }
  }
}
