import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/widgets/auth/auth_form.dart';

class AuthRoute extends StatefulWidget {
  const AuthRoute({Key? key}) : super(key: key);

  @override
  State<AuthRoute> createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitForm(
    String email,
    String password,
    String username,
    Uint8List userImage,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    var message = 'An error occurred, please check your credentials!';
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final newMetadata = SettableMetadata(
          cacheControl: "public,max-age=300",
          contentType: "image/jpeg",
        );
        final ref = FirebaseStorage.instance
            .ref()
            .child('user-image')
            .child('${authResult.user!.uid}.jpg');
        await ref.putData(userImage, newMetadata);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (e) {
      if (e.message != null) {
        message = e.message!;
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(ctx).errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (err) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(ctx).errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      // ignore: avoid_print
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm, _isLoading),
    );
  }
}
