import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userimage;
  const MessageBubble(this.message, this.isMe, this.username, this.userimage,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: isMe
                      ? Colors.grey[300]
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: !isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  )),
              width: 140,
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).colorScheme.onSecondary,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          top: 0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userimage),
          ),
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
