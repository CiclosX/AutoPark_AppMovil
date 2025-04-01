import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  //iniciar sesion con google
  Future <UserCredential> singInWithGoogle()async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //Obtener los detalles de la autencicacion
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //Crear credenciales de acceso con Google
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  //Regresa la credencial de acceso
  return await _firebaseAuth.signInWithCredential(credential);
  }
  //Cerrar sesion
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}