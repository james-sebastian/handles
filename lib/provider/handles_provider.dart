part of "providers.dart";

final handlesProvider = ChangeNotifierProvider<HandlesServices>(
  (ref) => HandlesServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  )
);

final singleHandlesProvider = StreamProvider.family<HandlesModel, String>(
  (ref, handlesID) => HandlesServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  ).handlesModelGetter(handlesID)
);
