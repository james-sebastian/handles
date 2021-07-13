part of "providers.dart";

final chatListProvider = StreamProvider.family<List<ChatModel>, String>(
  (ref, handlesID)  => ChatServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).handlesChats(handlesID)
);

final meetChatProvider = StreamProvider.family<MeetingModel, String>(
  (ref, meetID)  => ChatServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).getMeetingChat(meetID)
);

final projectChatProvider = StreamProvider.family<ProjectModel, String>(
  (ref, projectID)  => ChatServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).getProjectChat(projectID)
);

final projectChatMilestonesProvider = StreamProvider.family<List<MilestoneModel>, String>(
  (ref, projectID)  => ChatServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).getProjectMilestones(projectID)
);

final chatProvider = ChangeNotifierProvider<ChatServices>(
  (ref) => ChatServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  )
);