import '../constants/constants.dart';
import '../models/chat_models.dart';
import '../providers/models_provider.dart';
import '../services/api_services.dart';
import '../services/assets_manager.dart';
import '../widgets/chat_widget.dart';
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

  List<ChatModels> chatList = [];
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
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      message: chatList[index].message,
                      chatIndex: chatList[index].chatIndex,
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
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                          );
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
                        await sendMessageFCT(modelsProvider: modelsProvider);
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

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    final String message = textEditingController.text;
    textEditingController.clear();
    try {
      setState(() {
        isTyping = true;
        chatList.add(
          ChatModels(message: message, chatIndex: 0),
        );
        textEditingController.clear();
      });
      // log("Fetching:");
      chatList.addAll(await ApiService.sendMessage(
        message: message,
        model: modelsProvider.getCurrentModel,
      ));
      setState(() {});
    } catch (error) {
      print("error: $error");
    } finally {
      setState(() {
        isTyping = false;
      });
    }
  }
}
