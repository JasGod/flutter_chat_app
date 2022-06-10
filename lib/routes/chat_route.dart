import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_chat_app/widgets/chat/message.dart';
import 'package:flutter_chat_app/widgets/chat/new_message.dart';

class ChatRoute extends StatelessWidget {
  const ChatRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter_Chat'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              borderRadius: BorderRadius.zero,
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('Logout')
                    ],
                  ),
                  value: 'Logout',
                ),
              ],
              onChanged: (itemIdentifier) async {
                if (itemIdentifier == 'Logout') {
                  await FirebaseAuth.instance.signOut();
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
