part of "providers.dart";

final chatListProvider = StreamProvider.family<List<ChatModel>, String>(
  (ref, handlesID)  => ChatServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).handlesChats(handlesID)
);

final chatProvider = ChangeNotifierProvider<ChatServices>(
  (ref) => ChatServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  )
);