part of "services.dart";

class ChatServices with ChangeNotifier{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  bool isLoading = false;
  ChatServices({required this.auth, required this.firestore, required this.storage});

  ChatType chatTypeDeterminer(String type){
    ChatType typeOut = ChatType.plain;

    if(type == "status"){
      typeOut = ChatType.status;
    } else if (type == "plain"){
      typeOut = ChatType.plain;
    } else if (type == "image"){
      typeOut = ChatType.image;
    } else if (type == "video"){
      typeOut = ChatType.video;
    } else if (type == "docs"){
      typeOut = ChatType.docs;
    } else if (type == "voice"){
      typeOut = ChatType.voice;
    }

    return typeOut;
  }

  Stream<List<ChatModel>> handlesChats(String id){
    return firestore
    .collection("handles")
    .doc(id)
    .collection('messages')
    .orderBy('timestamp', descending: false)
    .snapshots()
    .map(handlesChatsMapper);
  }

  List<ChatModel> handlesChatsMapper(QuerySnapshot snapshot){
    List<ChatModel> out = [];

    snapshot.docs.forEach((chat) {
      out.add(ChatModel(
        id: chat.id,
        sender: chat['sender'],
        type: chatTypeDeterminer(chat['type']),
        content: chat['content'] ?? "",
        mediaURL: chat['mediaURL'] ?? "",
        isPinned: chat['isPinned'],
        readBy: (chat['readBy'] as List<dynamic>).cast<String>(),
        deletedBy: (chat['deletedBy'] as List<dynamic>).cast<String>(),
        timestamp: DateTime.parse(chat['timestamp'])
      ));
    });

    return out;
  }

  Future<void> sendPlainChat(String id, ChatModel chat) async{
    return firestore
    .collection("handles")
    .doc(id)
    .collection('messages')
    .doc()
    .set({
      "sender": chat.sender,
      "content": chat.content,
      "mediaURL": null,
      "type": "plain",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": []
    });
  }
}