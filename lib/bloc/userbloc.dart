import 'dart:async';
import 'package:srm_notes/bloc/bloc.dart';
import 'package:srm_notes/components/models/usermodel.dart';

class UserBloc extends Bloc {
  final userController = StreamController<List<RandomUserModel>>.broadcast();

  @override
  void dispose() {
    userController.close();
  }
}

UserBloc userBloc = UserBloc();
