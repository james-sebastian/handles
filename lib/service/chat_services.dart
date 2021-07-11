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
      "sender": auth.currentUser!.uid,
      "content": chat.content,
      "mediaURL": null,
      "type": "plain",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": []
    });
  }

  Future<String?> uploadImageURL(String filePath, String handlesName) async {
    String? outputURL;
    File file = File(filePath);
    String id = Uuid().v4();
    try {
      await storage
      .ref('handles_media/$handlesName/image/$id.${flutter_path.extension(filePath)}')
      .putFile(file);

      String downloadURL = await FirebaseStorage.instance
      .ref('handles_media/$handlesName/image/$id.${flutter_path.extension(filePath)}')
      .getDownloadURL();

      outputURL = downloadURL;
    } on FirebaseException catch (e) {
      print(e.toString());
    }

    return outputURL;
  }

  Future<void> sendImageChat(String id, ChatModel chat) async{
    return firestore
    .collection("handles")
    .doc(id)
    .collection('messages')
    .doc()
    .set({
      "sender": auth.currentUser!.uid,
      "content": chat.content,
      "mediaURL": chat.mediaURL,
      "type": "image",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": []
    });
  }

  Future<String?> uploadVideoURL(String filePath, String handlesName) async {
    String? outputURL;

    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      filePath,
      quality: VideoQuality.LowQuality, 
      deleteOrigin: false, // It's false by default
    );

    File file = File(mediaInfo!.path ?? "");
    String id = Uuid().v4();
    try {
      await storage
      .ref('handles_media/$handlesName/video/$id.${flutter_path.extension(filePath)}')
      .putFile(file);

      String downloadURL = await FirebaseStorage.instance
        .ref('handles_media/$handlesName/video/$id.${flutter_path.extension(filePath)}')
        .getDownloadURL();

      outputURL = downloadURL;
    } on FirebaseException catch (e) {
      print(e.toString());
    }

    return outputURL;
  }

  Future<void> sendVideoChat(String id, ChatModel chat) async{
    return firestore
    .collection("handles")
    .doc(id)
    .collection('messages')
    .doc()
    .set({
      "sender": auth.currentUser!.uid,
      "content": chat.content,
      "mediaURL": chat.mediaURL,
      "type": "video",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": []
    });
  }

  Future<String?> uploadDocument(String filePath, String handlesName) async {
    String? outputURL;
    File file = File(filePath);
    String id = Uuid().v4();
    try {
      await storage
      .ref('handles_media/$handlesName/docs/${flutter_path.basenameWithoutExtension(filePath)}.${flutter_path.extension(filePath)}')
      .putFile(file);

      String downloadURL = await FirebaseStorage.instance
        .ref('handles_media/$handlesName/docs/${flutter_path.basenameWithoutExtension(filePath)}.${flutter_path.extension(filePath)}')
        .getDownloadURL();

      outputURL = downloadURL;
    } on FirebaseException catch (e) {
      print(e.toString());
    }

    return outputURL;
  }

  Future<void> sendDocumentChat(String id, ChatModel chat) async{
    return firestore
    .collection("handles")
    .doc(id)
    .collection('messages')
    .doc()
    .set({
      "sender": auth.currentUser!.uid,
      "content": chat.content,
      "mediaURL": chat.mediaURL,
      "type": "docs",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": []
    });
  }
}