import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';

class RequestResult {
  dynamic data;
  int ch;
  RequestResult(this.data, this.ch);
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final CollectionReference realestate =
    FirebaseFirestore.instance.collection('realestate');
Future<RequestResult> signInwithEmailAndPassword2(
  String email,
  String password,
) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return RequestResult(credential.user, 1);
  } on auth.FirebaseAuthException catch (e) {
    return RequestResult(e.message, 0);
  }
}

Future<RequestResult> CreateUserwithEmailAndPassword(
  String name,
  String email,
  String password,
) async {
  try {
    final credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      await user.user!.updateDisplayName(name);
      await user.user!.reload();
    });
    return RequestResult(credential, 1);
  } on auth.FirebaseAuthException catch (e) {
    print('this is error:$e');
    return RequestResult(e.message, 0);
  }
}

Future<RequestResult> addItem(
    {required String uid,
    required String name,
    required String url,
    required String description,
    required String purpose,
    required String location,
    required int? price,
    required int? sqm,
    required int num_bed,
    required int num_bath,
    required int num_ket,
    required int num_bark,
    required List image}) async {
  DocumentReference documentReferencer = realestate.doc();

  Map<String, dynamic> data = <String, dynamic>{
    "uid": uid,
    "name": name,
    "image": url,
    "description": description,
    "purpose": purpose,
    "location": location,
    "price": price,
    "sqm": sqm,
    "num_bed": num_bed,
    "num_bath": num_bath,
    "num_ket": num_ket,
    "num_bark": num_bark,
    "images": image
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("Notes item added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}

Future<RequestResult> addComment(
    {required String user_id,
    required String post_id,
    required String title,
    required String code,
    required List image}) async {
  DocumentReference documentReferencer =
      FirebaseFirestore.instance.collection('Comment').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "user_id": user_id,
    "post_id": post_id,
    "comment": title,
    "code": code,
    "image": image
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("Notes item added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}

Future<RequestResult> addPost(
    {required String user_id,
    required String user_image,
    required String name,
    required String title,
    required String desc,
    required List image}) async {
  DocumentReference documentReferencer =
      FirebaseFirestore.instance.collection('Post').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "user_id": user_id,
    "user_image": user_image,
    "user_name": name,
    "title": title,
    "description": desc,
    "image": image
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("Notes item added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}

Future<RequestResult> addFeddback({
  required String title,
}) async {
  DocumentReference documentReferencer =
      FirebaseFirestore.instance.collection('feedback').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "text": title,
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("Notes item added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}

Future<RequestResult> saveRecommend({
  required String id,
}) async {
  DocumentReference documentReferencer =
      FirebaseFirestore.instance.collection('SaveRecommend').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "id": id,
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("Notes item added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}

Future<RequestResult> savePost(
    {required String id,
    required String user_id,
    required String name,
    required String title,
    required String desc,
    required List image}) async {
  DocumentReference documentReferencer =
      FirebaseFirestore.instance.collection('SavePost').doc(id);

  Map<String, dynamic> data = <String, dynamic>{
    "user_id": user_id,
    "user_name": name,
    "title": title,
    "description": desc,
    "image": image
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("Notes item added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}
