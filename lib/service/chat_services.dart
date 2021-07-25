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
    } else if (type == "meets"){
      typeOut = ChatType.meets;
    } else if (type == "project"){
      typeOut = ChatType.project;
    }
    return typeOut;
  }

  String projectStatusDeterminer(ProjectStatus status){
    String out = "";
    if (status == ProjectStatus.completed){
      out = "completed";
    } else if (status == ProjectStatus.in_progress){
      out = "in_progress";
    } else if (status == ProjectStatus.pending){
      out = "pending";
    }
    return out;
  }

  String projectPaymentStatusDeterminer(ProjectPaymentStatus paymentStatus){
    String out = "";
    if(paymentStatus == ProjectPaymentStatus.paid){
      out = "paid";
    } else if (paymentStatus == ProjectPaymentStatus.unpaid){
      out = "unpaid";
    }
    return out;
  }

  ProjectStatus projectStatusGetter(String raw){
    ProjectStatus out = ProjectStatus.pending;
    
    if(raw == "pending"){
      out = ProjectStatus.pending;
    } else if(raw == "completed"){
      out = ProjectStatus.completed;
    } else if(raw == "in_progress"){
      out = ProjectStatus.in_progress;
    }

    return out;
  }

  ProjectPaymentStatus projectStatusPaymentGetter(String raw){
    ProjectPaymentStatus out = ProjectPaymentStatus.unpaid;
    
    if(raw == "paid"){
      out = ProjectPaymentStatus.paid;
    } else if(raw == "unpaid"){
      out = ProjectPaymentStatus.unpaid;
    } 

    return out;
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
        replyTo: chat['replyTo'] ?? "",
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
      "readBy": [],
      "replyTo": chat.replyTo
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
      "readBy": [],
      "replyTo": chat.replyTo
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
      "readBy": [],
      "replyTo": chat.replyTo
    });
  }

  Future<String?> uploadDocument(String filePath, String handlesName) async {
    String? outputURL;
    File file = File(filePath);
    String name = flutter_path.basenameWithoutExtension(filePath);
    try {
      await storage
      .ref('handles_media/$handlesName/docs/$name.${flutter_path.extension(filePath)}')
      .putFile(file);

      String downloadURL = await FirebaseStorage.instance
        .ref('handles_media/$handlesName/docs/$name.${flutter_path.extension(filePath)}')
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
      "readBy": [],
      "replyTo": chat.replyTo
    });
  }

  Future<void> sendMeetingChat(String handlesID, MeetingModel meetChat) async{

    var id = Uuid().v4();

    await firestore
    .collection("meet_chat")
    .doc(id)
    .set({
      "meetingName": meetChat.meetingName,
      "meetingURL": meetChat.meetingURL,
      "description": meetChat.description,
      "startTime": meetChat.meetingStartTime,
      "endTime": meetChat.meetingEndTime,
      "attendees": meetChat.attendees,
      "isPinned": false,
      "sender": auth.currentUser!.uid,
      "timestamp": DateTime.now().toString(),
    });

    return firestore
    .collection("handles")
    .doc(handlesID)
    .collection('messages')
    .doc(id)
    .set({
      "sender": auth.currentUser!.uid,
      "content": "",
      "mediaURL": id,
      "type": "meets",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": [],
      "replyTo": ""
    });
  }

  Future<void> editMeetingChat(String handlesID, MeetingModel meetingModel) async{
    await firestore
    .collection("meet_chat")
    .doc(meetingModel.id)
    .set({
      "meetingName": meetingModel.meetingName,
      "meetingURL": meetingModel.meetingURL,
      "description": meetingModel.description,
      "startTime": meetingModel.meetingStartTime,
      "endTime": meetingModel.meetingEndTime,
      "attendees": meetingModel.attendees,
      "isPinned": false,
      "sender": auth.currentUser!.uid,
      "timestamp": DateTime.now().toString(),
    });

    return firestore
    .collection("handles")
    .doc(handlesID)
    .collection('messages')
    .doc(meetingModel.id)
    .update({
      "sender": auth.currentUser!.uid,
      "content": "",
      "mediaURL": meetingModel.id,
      "type": "meets",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": []
    });
  }

  Future<void> deleteMeetingChat(String handlesID, String meetChatID) async{
    await firestore
    .collection("meet_chat")
    .doc(meetChatID)
    .delete();

    return firestore
    .collection("handles")
    .doc(handlesID)
    .collection('messages')
    .doc(meetChatID)
    .delete();
  }

  Stream<MeetingModel> getMeetingChat(String meetChatID){
    return firestore
    .collection("meet_chat")
    .doc(meetChatID)
    .snapshots()
    .map((doc){
      return MeetingModel(
        id: doc.id,
        timestamp: DateTime.parse(doc["timestamp"]),
        meetingEndTime: (doc["endTime"] as Timestamp).toDate(),
        meetingStartTime: (doc["startTime"] as Timestamp).toDate(),
        attendees: (doc["attendees"] as List<dynamic>).cast<String>(),
        meetingURL: doc["meetingURL"],
        description: doc["description"],
        meetingName: doc["meetingName"],
        isPinned: doc["isPinned"],
        sender: doc["sender"]
      );
    });
  }

  Stream<ProjectModel> getProjectChat(String projectChatID){
    return firestore
    .collection("project_chat")
    .doc(projectChatID)
    .snapshots()
    .map((doc){
      return ProjectModel(
        id: doc.id,
        serviceName: doc["serviceName"],
        description: doc["description"],
        status: projectStatusGetter(doc['status']),
        paymentStatus: projectStatusPaymentGetter(doc['paymentStatus']),
        timestamp: DateTime.parse(doc['timestamp']),
        isPinned: doc['isPinned'],
        sender: doc['sender'],
      );
    });
  }

  Stream<List<MilestoneModel>> getProjectMilestones(String projectChatID){
    return firestore
    .collection("project_chat")
    .doc(projectChatID)
    .collection("milestones")
    .snapshots()
    .map((snapshot){
      List<MilestoneModel> milestones = [];
      snapshot.docs.forEach((doc) {
        milestones.add(
          doc["dueDate"] == "null"
          ? MilestoneModel(
              id: doc.id,
              milestoneName: doc["milestoneName"],
              description: doc["description"],
              status: projectStatusGetter(doc["status"]),
              paymentStatus: projectStatusPaymentGetter(doc["paymentStatus"]),
              isCompleted: doc["isCompleted"],
              fee: doc["fee"],
            )
          : MilestoneModel(
              id: doc.id,
              milestoneName: doc["milestoneName"],
              description: doc["description"],
              status: projectStatusGetter(doc["status"]),
              paymentStatus: projectStatusPaymentGetter(doc["paymentStatus"]),
              isCompleted: doc["isCompleted"],
              fee: doc["fee"],
              dueDate: DateTime.parse(doc["dueDate"]),
            )
        );
      });

      return milestones;
    });
  }

  Future<void> sendProjectChat(String handlesID, ProjectModel projectChat) async{
    await firestore
    .collection("project_chat")
    .doc(projectChat.id)
    .set({
      "serviceName": projectChat.serviceName,
      "description": projectChat.description,
      "timestamp": DateTime.now().toString(),
      "status": projectStatusDeterminer(projectChat.status),
      "paymentStatus": projectPaymentStatusDeterminer(projectChat.paymentStatus),
      "isPinned": false,
      "sender": auth.currentUser!.uid,
    });

    if(projectChat.milestones != null){
      projectChat.milestones!.forEach((milestone) async {
        await firestore
        .collection("project_chat")
        .doc(projectChat.id)
        .collection("milestones")
        .doc()
        .set({
          "milestoneName": milestone.milestoneName,
          "description": milestone.description,
          "dueDate": milestone.dueDate.toString(),
          "fee": milestone.fee,
          "paymentStatus": projectPaymentStatusDeterminer(milestone.paymentStatus),
          "status": projectStatusDeterminer(milestone.status),
          "isCompleted": milestone.isCompleted
        });
      });
    }

    return firestore
    .collection("handles")
    .doc(handlesID)
    .collection('messages')
    .doc(projectChat.id)
    .set({
      "sender": auth.currentUser!.uid,
      "content": "",
      "mediaURL": projectChat.id,
      "type": "project",
      "timestamp": DateTime.now().toString(),
      "isPinned": false,
      "deletedBy": [],
      "readBy": [],
      "replyTo": ""
    });
  }

  Future<void> editProjectChat(String projectChatID, ProjectModel projectModel) async {
    await firestore
    .collection("project_chat")
    .doc(projectModel.id)
    .update({
      "serviceName": projectModel.serviceName,
      "description": projectModel.description,
      "timestamp": projectModel.timestamp.toString(),
      "status": projectStatusDeterminer(projectModel.status),
      "paymentStatus": projectPaymentStatusDeterminer(projectModel.paymentStatus),
      "isPinned": projectModel.isPinned,
      "sender": projectModel.sender,
    });

    projectModel.milestones!.forEach((milestone) async {
      await firestore
      .collection("project_chat")
      .doc(projectModel.id)
      .collection("milestones")
      .doc(milestone.id)
      .set({
        "milestoneName": milestone.milestoneName,
        "description": milestone.description,
        "dueDate": milestone.dueDate.toString(),
        "fee": milestone.fee,
        "paymentStatus": projectPaymentStatusDeterminer(milestone.paymentStatus),
        "status": projectStatusDeterminer(milestone.status),
        "isCompleted": milestone.isCompleted
      });
    });
  }

  Future<void> deleteProjectChat(String handlesID, ProjectModel projectChat) async{

    print(projectChat.id);
    print(handlesID);

    await firestore
    .collection("project_chat")
    .doc(projectChat.id)
    .collection("milestones")
    .get().then((value){
      if(value.docs.isNotEmpty){
        value.docs.forEach((element) {
          firestore
          .collection("project_chat")
          .doc(projectChat.id)
          .collection("milestones")
          .doc(element.id)
          .delete();
        });
      }
    });

    await firestore
    .collection("project_chat")
    .doc(projectChat.id)
    .delete();

    return firestore
    .collection("handles")
    .doc(handlesID)
    .collection('messages')
    .doc(projectChat.id)
    .delete();
  }

  Future<void> markMilestoneAsWorking(String projectChatID, String milestoneID) async {
    return firestore
    .collection("project_chat")
    .doc(projectChatID)
    .collection("milestones")
    .doc(milestoneID)
    .update({
      "status": "in_progress"
    });
  }

  Future<void> markMilestoneAsCompleted(String projectChatID, String milestoneID) async {
    return firestore
    .collection("project_chat")
    .doc(projectChatID)
    .collection("milestones")
    .doc(milestoneID)
    .update({
      "status": "completed"
    });
  }

  Future<void> markMilestoneAsPaid(String projectChatID, String milestoneID) async {
    return firestore
    .collection("project_chat")
    .doc(projectChatID)
    .collection("milestones")
    .doc(milestoneID)
    .update({
      "paymentStatus": "paid"
    });
  }

  Future<void> deleteMilestone(String projectChatID, String milestoneID) async {
    return firestore
    .collection("project_chat")
    .doc(projectChatID)
    .collection("milestones")
    .doc(milestoneID)
    .delete();
  }

  Future<void> deleteChat(String handlesID, String targetChatID, List<String> newDeletedBy) async{
    return firestore
    .collection('handles')
    .doc(handlesID)
    .collection('messages')
    .doc(targetChatID)
    .update({
      "deletedBy": newDeletedBy
    });
  }

  Future<void> pinChat(String handlesID, String targetChatID, bool pinValue) async{
    return firestore
    .collection('handles')
    .doc(handlesID)
    .collection('messages')
    .doc(targetChatID)
    .update({
      "isPinned": pinValue
    });
  }

  Stream<List<ChatModel>> getPinnedChats(String handlesID){
    return firestore
    .collection("handles")
    .doc(handlesID)
    .collection('messages')
    .where('isPinned', isEqualTo: true)
    .orderBy('timestamp', descending: false)
    .snapshots()
    .map(handlesChatsMapper);
  }

  Future<void> readChat(String handlesID, String chatID, List<String> newReadBy){
    return firestore
    .collection("handles")
    .doc(handlesID)
    .collection('messages')
    .doc(chatID)
    .update({
      "readBy": newReadBy
    });
  }
}