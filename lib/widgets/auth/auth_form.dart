import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      Uint8List userImage, bool isLogin, BuildContext ctx) handleForm;
  final bool isLoading;
  const AuthForm(this.handleForm, this.isLoading, {Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _useremail = '';
  var _username = '';
  var _userpassword = '';
  Uint8List? _userImage;

  void _pickedImage(Uint8List image) {
    _userImage = image;
  }

  void _firstSubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please pick a image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.handleForm(
        _useremail.trim(),
        _userpassword.trim(),
        _username.trim(),
        _userImage!,
        _isLogin,
        context,
      );
      debugPrint(_useremail);
      debugPrint(_username);
      debugPrint(_userpassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a good email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                    onSaved: (value) {
                      _useremail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter a username with more character';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.words,
                      autocorrect: true,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Please enter a strong password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userpassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _firstSubmit,
                      child: Text(_isLogin ? 'Login' : 'SignUp'),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'create new account'
                          : 'I already have an account.'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
