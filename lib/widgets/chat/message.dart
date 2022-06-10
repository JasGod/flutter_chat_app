import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const centerWaiting = Center(
      child: CircularProgressIndicator(),
    );
    return FutureBuilder(
      future: Future.delayed(
          const Duration(seconds: 0), () => FirebaseAuth.instance.currentUser),
      builder: (context, AsyncSnapshot<User?> futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return centerWaiting;
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy(
                'createAt',
                descending: true,
              )
              .snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return centerWaiting;
            }
            final chatDocs = chatSnapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, i) {
                return MessageBubble(
                  chatDocs[i]['text'],
                  chatDocs[i]['userId'] == futureSnapshot.data!.uid,
                  chatDocs[i]['username'],
                  chatDocs[i]['userImage'],
                  key: ValueKey(chatDocs[i].id),
                );
              },
            );
          }),
        );
      },
    );
  }
}
