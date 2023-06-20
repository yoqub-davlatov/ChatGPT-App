import 'dart:developer';

import 'package:chatgpt_chat/constants/constants.dart';
import 'package:chatgpt_chat/providers/models_provider.dart';
import 'package:chatgpt_chat/services/api_services.dart';
import 'package:chatgpt_chat/services/assets_manager.dart';
import 'package:chatgpt_chat/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "ChatGPT",
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openAILogo),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      message: chatMessages[index]['msg'].toString(),
                      chatIndex: int.parse(
                          chatMessages[index]['chatIndex'].toString()),
                    );
                  }),
            ),
            if (isTyping)
              const SpinKitPouringHourGlassRefined(
                color: Colors.white,
                size: 30,
              ),
            const SizedBox(
              height: 10,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) {
                          // TODO send message
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you?",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            isTyping = true;
                          });
                          log("Fetching:");
                          await ApiService.sendMessage(
                            message: textEditingController.text,
                            model: modelsProvider.getCurrentModel,
                          );
                        } catch (error) {
                          print("error: $error");
                        } finally {
                          setState(() {
                            isTyping = false;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
