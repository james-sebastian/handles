part of "providers.dart";

final callProvider = Provider<CallServices>(
  (ref) => CallServices(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firebaseFirestoreProvider),
    storage: ref.watch(firebaseStorageProvider)
  )
);