import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

Future<void> phoneVerification(String phone, Function(String vid,int? a) fn) async {

  await auth.verifyPhoneNumber(
    phoneNumber: "+91$phone",
    timeout: const Duration(seconds: 60),
    verificationCompleted: (AuthCredential credential)async{
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e){
    },
    codeSent: fn,
    codeAutoRetrievalTimeout: (String verificationId){},
  );
}
