import 'package:d_chat/ChatApp/Models/ChatMessageModel.dart';
import 'package:d_chat/ChatApp/Models/ChatUserData.dart';
import 'package:d_chat/ChatApp/Utils/my_date_util.dart';
import 'package:d_chat/ChatApp/Views/ChatMessageScreen/ChatMessageScreenView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controller/DataApi/DataApiCloudStore.dart';
import '../../ProfileScreenView/ProfileScreen/ProfileDialog.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({Key? key, required this.user, required this.isSelected})
      : super(key: key);
  final ChatUser user;
  final bool isSelected;

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  ChatMessageModel? chatMessageModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.isSelected ? Colors.white10.withOpacity(0.1) : Colors.white,
      child: InkWell(
          onTap: () {
            //for navigating to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatMessageScreenView(user: widget.user)));
          },
          child: StreamBuilder(
            stream: DataApiCloudStore.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list = data
                      ?.map((e) => ChatMessageModel.fromJson(e.data()))
                      .toList() ??
                  [];
              if (list.isNotEmpty) chatMessageModel = list[0];

              return ListTile(
                  //user profile picture
                  leading: Container(
                    height: 60,
                    width: 60,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => ProfileDialog(user: widget.user));
                      },
                      child: CircleAvatar(
                        radius: Get.height * .0275,
                        backgroundImage: NetworkImage(widget.user.image),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),

                  //user name
                  title: Text(widget.user.name),

                  //last message
                  subtitle: Text(
                      chatMessageModel != null
                          ? chatMessageModel!.type == Type.image
                              ? 'image'
                              : chatMessageModel!.msg
                          : widget.user.about,
                      maxLines: 1),

                  //last message time
                  trailing: chatMessageModel == null
                      ? null //show nothing when no message is sent
                      : chatMessageModel!.read.isEmpty &&
                              chatMessageModel!.fromId !=
                                  DataApiCloudStore.user.uid
                          ?
                          //show for unread message
                          Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.greenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          :
                          //message sent time
                          Text(
                              myDateUtil.getLastMessageTime(
                                  context: context,
                                  time: chatMessageModel!.send),
                              style: TextStyle(color: Colors.black54),
                            ));
            },
          )),
    );
  }
}
