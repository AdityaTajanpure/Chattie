import 'dart:io';
import 'package:chattie/DatabaseServices/FileUpload.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  String verificationId;
  String smsOTP;
  File _image;

  Future<String> signIn(
      {String name, String phoneNo, File image, Function showDialog}) async {
    this._image = image;
    try {
      final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
        verificationId = verId;
        showDialog();
      };
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (AuthCredential phoneAuthCredential) async {
          UserCredential result =
              await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          User user = result.user;
          if (user != null) return 'Signed In';
        },
        verificationFailed: handleError,
        codeSent: smsOTPSent,
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  logInUserAfterOTP() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);
      final User user = result.user;
      if (user != null) {
        print(user);
        var data = await FileUpload().uploadPic(_image, user.uid);
        print(data);
      }
    } catch (e) {
      handleError(e);
    }
  }

  String handleError(e) {
    return e.code;
  }
}
