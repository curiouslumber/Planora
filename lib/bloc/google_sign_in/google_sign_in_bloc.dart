import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'google_sign_in_event.dart';
part 'google_sign_in_state.dart';

class GoogleSignInBloc extends Bloc<GoogleSignInEvent, GoogleSignInState> {
  GoogleSignInBloc() : super(GoogleSignInInitial()) {
    on<GoogleSignInEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
