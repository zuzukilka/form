import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/user.dart';
import 'user_info_page.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({super.key});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _idController = TextEditingController();
  final _genderController = TextEditingController();

  final List<String> _countries = ['Russia', 'Ukraine', 'Germany', 'France', 'Kazakhstan'];
  String _selectedCountry = 'Russia';
  final List<String> _genders = ['Male', 'Female'];
  String _selectedGender  = 'Male';

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();
  final _idFocus = FocusNode();
  final _genderFocus = FocusNode();

  User newUser = User();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _idController.dispose();
    _genderController.dispose();
    _confirmPassController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    _idFocus.dispose();
    _genderFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Register Form'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              focusNode: _nameFocus,
              autofocus: true,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _nameFocus, _phoneFocus);
              },
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'What do people call you?',
                prefixIcon: const Icon(Icons.person),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _nameController.clear();
                  },
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              validator: validateName,
              onSaved: (value) => newUser.name = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              focusNode: _phoneFocus,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _phoneFocus, _passFocus);
              },
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: 'Where can we reach you?',
                helperText: 'Phone format: (XXX)XXX-XXXX',
                prefixIcon: const Icon(Icons.call),
                suffixIcon: GestureDetector(
                  onLongPress: () {
                    _phoneController.clear();
                  },
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                    allow: true),
              ],
              validator: (value) => validatePhoneNumber(value!)
                  ? null
                  : 'Phone number must be entered as (###)###-####',
              onSaved: (value) => newUser.phone = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter a email address',
                icon: Icon(Icons.mail),
              ),
              keyboardType: TextInputType.emailAddress,
              // validator: _validateEmail,
              onSaved: (value) => newUser.email = value!,
            ),
               const SizedBox(height: 20),
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Barcode',
                hintText: 'Your barcode',
                border: OutlineInputBorder(),
              ),
              maxLength: 8,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter(RegExp(r'^[()\d -]{1,15}$'),
                    allow: true),
              ],
              onSaved: (value) => newUser.id = value!,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.map),
                  labelText: 'Country?'),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (country) {
                setState(() {
                  _selectedCountry = country as String;
                  newUser.country = country;
                });
              },
              value: _selectedCountry,
              // validator: (val) {
              //   return val == null ? 'Please select a country' : null;
              // },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.male),
                  labelText: 'Male?'),
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (gender) {
                setState(() {
                  _selectedGender = gender as String;
                  newUser.gender = gender;
                });
              },
              value: _selectedGender,
              // validator: (val) {
              //   return val == null ? 'Please select a country' : null;
              // },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _storyController,
              decoration: const InputDecoration(
                labelText: 'Life Story',
                hintText: 'Tell us about your self',
                helperText: 'Keep it short, this is just a demo',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
              onSaved: (value) => newUser.story = value!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              focusNode: _passFocus,
              controller: _passController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: 'Enter the password',
                suffixIcon: IconButton(
                  icon:
                      Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _hidePass = !_hidePass;
                    });
                  },
                ),
                icon: const Icon(Icons.security),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPassController,
              obscureText: _hidePass,
              maxLength: 8,
              decoration: const InputDecoration(
                labelText: 'Confirm Password *',
                hintText: 'Confirm the password',
                icon: Icon(Icons.border_color),
              ),
              validator: _validatePassword,
            ),
            
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(color: Colors.white),
              ),
              child: const Text('Submit Form'),
              //color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _showDialog(name: _nameController.text);
      log('Name: ${_nameController.text}');
      log('Phone: ${_phoneController.text}');
      log('Email: ${_emailController.text}');
      log('Country: $_selectedCountry');
      log('Gender: $_selectedGender');
      log('Story: ${_storyController.text}');
    } else {
      _showMessage(message: 'Form is not valid! Please review and correct');
    }
  }

  String? validateName(String? value) {
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (value == null) {
      return 'Name is reqired.';
    } else if (!nameExp.hasMatch(value)) {
      return 'Please enter alphabetical characters.';
    } else {
      return null;
    }
  }

  bool validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return phoneExp.hasMatch(input);
  }

  String? validateEmail(String? value) {
    if (value == null) {
      return 'Email cannot be empty';
    } else if (!_emailController.text.contains('@')) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (_passController.text.length != 8) {
      return '8 character required for password';
    } else if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    } else {
      return null;
    }
  }

  void _showMessage({required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
      ),
    );
    // До Flutter 2.0
    // _scaffoldKey.currentState.showSnackBar(
    //   SnackBar(
    //     duration: Duration(seconds: 5),
    //     backgroundColor: Colors.red,
    //     content: Text(
    //       message,
    //       style: TextStyle(
    //         color: Colors.black,
    //         fontWeight: FontWeight.w600,
    //         fontSize: 18.0,
    //       ),
    //     ),
    //   ),
    // );
  }

  void _showDialog({required String name}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Registration successful',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
          content: Text(
            '$name is now a verified register form',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfoPage(
                      userInfo: newUser,
                    ),
                  ),
                );
              },
              child: const Text(
                'Verified',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
