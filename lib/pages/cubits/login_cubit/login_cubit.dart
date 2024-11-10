import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          emit(LoginFailure(errorMessage: 'user-not-found'));
          break;
        case 'wrong-password':
          emit(LoginFailure(errorMessage: 'Wrong password'));
          break;
        case 'invalid-credential':
          emit(LoginFailure(errorMessage: 'Invalid email or password'));
          break;
        default:
          emit(LoginFailure(errorMessage: 'There is an error'));
      }
    }
  }
}
