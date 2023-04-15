import 'package:flutter/material.dart';

import 'models/message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // socketio
  TextEditingController messageInputController = TextEditingController();
  // ScrollController scrollController;
  late FocusNode focusInput;
  late List<Message> messages;

  void handleMessageInput() {
    // ignore: avoid_print
    print(messageInputController.text);
  }

  @override
  void initState() {
    messageInputController.addListener(handleMessageInput);
    focusInput = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the
    // widget tree.
    messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 120.0,
            height: double.infinity,
            color: Colors.black26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                ElevatedButton(
                  child: const Text('Button 1'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Button 2'),
                  onPressed: () {},
                ),
                ElevatedButton(
                  child: const Text('Button 3'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        title: Text('Chat message 1'),
                      ),
                      ListTile(
                        title: Text('Chat message 2'),
                      ),
                      ListTile(
                        title: Text('Chat message 3'),
                      ),
                      // Add more chat messages here
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: TextField(
                      controller: messageInputController,
                      autofocus: true,
                      enableSuggestions: false,
                      expands: false,
                      focusNode: focusInput,
                      onSubmitted: (String str) {
                        focusInput.requestFocus();
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
