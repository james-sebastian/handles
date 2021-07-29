part of "providers.dart";

final callProvider = Provider<CallServices>(
  (ref) => CallServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  )
);

final callChannelProvider = StreamProvider.family<CallModel, String>(
  (ref, handlesID)  => CallServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).getCallChannel(handlesID)
);

final filteredCallProvider = StreamProvider<List<CallModel>>(
  (ref)  => CallServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).getFilteredCallChannel()
);