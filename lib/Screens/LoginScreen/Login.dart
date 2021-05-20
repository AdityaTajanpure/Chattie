import 'dart:io';
import 'package:chattie/AuthServices/AuthenticationService.dart';
import 'package:chattie/Services/Intent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../DatabaseServices/FileUpload.dart';
import '../../DataModels/UserData.dart';
import '../../DatabaseServices/UserLogin.dart';
import '../HomeScreen/HomeScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phoneNo, name;
  String smsOTP;
  String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Country _selected = Country.IN;
  bool show = false;
  File _image;
  final picker = ImagePicker();

  Future<void> verifyPhone(UserData userData) async {
    print("+" + _selected.dialingCode + phoneNo);
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context, userData).then((value) {
        print('signing in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber:
              "+" + _selected.dialingCode + phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            UserCredential result =
                await _auth.signInWithCredential(phoneAuthCredential);
            User user = result.user;
            Navigator.of(context).pop();
            if (user != null) {
              String data = await FileUpload().uploadPic(_image, user.uid);
              UserLogin(uid: user.uid).updateUserData(name, phoneNo, data);
              UserLogin(uid: user.uid).getUserData(userData);

              Navigator.push(
                  context, AppIntents.createRoute(widget: HomeScreen()));
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            handleError(exception);
          });
    } catch (e) {
      Navigator.of(context).pop();
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context, UserData userData) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              TextButton(
                child: Text('Done'),
                onPressed: () {
                  signIn(userData);
                },
              )
            ],
          );
        });
  }

  Future<bool> loading(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: Text('Loading'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ));
        });
  }

  signIn(UserData userData) async {
    loading(context);
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential result =
          await _auth.signInWithCredential(credential);
      final User user = result.user;
      if (user != null) {
        String data = await FileUpload().uploadPic(_image, user.uid);
        UserLogin(uid: user.uid).updateUserData(name, phoneNo, data);
        UserLogin(uid: user.uid).getUserData(userData);
        Navigator.push(context, AppIntents.createRoute(widget: HomeScreen()));
      }
    } catch (e) {
      Navigator.of(context).pop();
      handleError(e);
    }
  }

  handleError(error) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: 'Error:  ${error.code} ',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black);
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<UserData>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.message_outlined,
                      size: 40,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(
                      'Hey,\nLogin Into Chattie',
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 35,
                ),
                InkWell(
                  onTap: getImage,
                  child: _image == null
                      ? Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            size: 30,
                          ),
                        )
                      : Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            image: DecorationImage(
                                image: FileImage(_image), fit: BoxFit.contain),
                          ),
                        ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Select Profile Picture:',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      'Enter Your Name:',
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: new TextField(
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                    decoration: new InputDecoration(
                      labelText: "Enter your Name",
                      border: OutlineInputBorder(),
                    ),

                    onChanged: (value) => this.name = value,
                    // Only numbers can be entered
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Enter Your Number:',
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: new Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: CountryPicker(
                          dense: false,
                          showName: false,
                          showDialingCode: true,
                          showFlag: true,
                          onChanged: (Country country) {
                            setState(() {
                              _selected = country;
                            });
                          },
                          selectedCountry: _selected,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.65,
                      child: new TextField(
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 18),
                        maxLength: 10,
                        decoration: new InputDecoration(
                          labelText: "Enter your number",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) => this.phoneNo = value,
                        // Only numbers can be entered
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    if (this.name == null || this.phoneNo == null) {
                      Fluttertoast.showToast(
                          msg: 'Fill all Fields',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                          textColor: Colors.black);
                    }
                    if (this.name != '' || this.phoneNo != '')
                      verifyPhone(userData);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
