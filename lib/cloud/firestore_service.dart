import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> create(
      {required String collection,
      required String documentId,
      required Map<String, dynamic> data,
      String? subcollection,
      String? subdocumentId,
      bool merge = true}) async {
    if (subcollection == null && subdocumentId == null) {
      await _db
          .collection(collection)
          .doc(documentId)
          .set(data, SetOptions(merge: merge));
    } else {
      try {
        // subcollection subdocument
        //redundant data
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(documentId)
            .collection(subcollection!)
            .doc(subdocumentId)
            .set(data, SetOptions(merge: merge));
      } catch (e) {
        print('Error creating document with subcollection: $e');
        rethrow;
      }
    }
  }

  Future<dynamic> read({
    required String collection,
    String? documentId,
  }) async {
    try {
      if (documentId == null) {
        QuerySnapshot querySnapshot = await _db
            .collection(collection)
            .get();
        return querySnapshot;
      } else {
        DocumentSnapshot snapshot =
            await _db.collection(collection).doc(documentId).get();
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print(
          'Something went wrong FirestoreService.read $collection $documentId $e');
      return null;
    }
  }

  // Future<dynamic> read(
  //     {required String collection,
  //     required String documentId,
  //     String? subcollection,
  //     String? subdocumentId}) async {
  //   try {
  //     if (subcollection == null && subdocumentId == null) {
  //       DocumentSnapshot snapshot =
  //           await _db.collection(collection).doc(documentId).get();
  //       return snapshot.data() as Map<String, dynamic>;
  //     } else if (subcollection != null && subdocumentId != null) {
  //       DocumentSnapshot snapshot = await _db
  //           .collection(collection)
  //           .doc(documentId)
  //           .collection(subcollection)
  //           .doc(subdocumentId)
  //           .get();
  //       return snapshot.data() as Map<String, dynamic>;
  //     } else {
  //       QuerySnapshot querySnapshot = await _db
  //           .collection(collection)
  //           .doc(documentId)
  //           .collection(subcollection!)
  //           .get();
  //       return querySnapshot;
  //     }
  //   } catch (e) {
  //     print(
  //         'Something went wrong FirestoreService.read $collection $documentId $e');
  //     return null;
  //   }
  // }

  Future<void> update(
      {required String collection,
      required String documentId,
      required Map<String, dynamic> data,
      String? subcollection,
      String? subdocumentId}) async {
    if (subcollection == null || subdocumentId == null) {
      await _db.collection(collection).doc(documentId).update(data);
    } else {
      await _db
          .collection(collection)
          .doc(documentId)
          .collection(subcollection)
          .doc(subdocumentId)
          .update(data);
    }
  }

  Future<void> delete(
      {required String collection,
      required String documentId,
      String? subcollection,
      String? subdocumentId}) async {
    if (subcollection == null && subdocumentId == null) {
      await _db.collection(collection).doc(documentId).delete();
    } else {
      await _db
          .collection(collection)
          .doc(documentId)
          .collection(subcollection!)
          .doc(subdocumentId)
          .delete();
    }
  }

  Future<void> deleteField(
      {required String collection,
      required String documentId,
      required String field,
      String? subcollection,
      String? subdocumentId}) async {
    if (subcollection == null && subdocumentId == null) {
      await _db.collection(collection).doc(documentId).update({
        field: FieldValue.delete(),
      });
    } else {
      await _db
          .collection(collection)
          .doc(documentId)
          .collection(subcollection!)
          .doc(subdocumentId)
          .update({
        field: FieldValue.delete(),
      });
    }
  }
}
