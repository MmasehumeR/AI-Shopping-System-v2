// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final Future<FirebaseApp> initialization = Firebase.initializeApp();

FirebaseFirestore firebaseFiretore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
GoogleSignIn googleSignIn = GoogleSignIn();
String? uid;
