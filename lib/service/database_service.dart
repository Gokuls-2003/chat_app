import 'package:chat_app/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _userscollection;

  DatabaseService() {
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _userscollection =
        _firebaseFirestore.collection("users").withConverter<UserProfile>(
            fromFirestore: (snapshots, _) => UserProfile.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (userProfile, _) => userProfile.toJson());
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _userscollection?.doc(userProfile.uid).set(userProfile);
  }
}
