import 'package:equatable/equatable.dart';
import 'package:hangman/models/models.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserUninitialized extends UserState {
  @override
  List<Object?> get props => [];
}

class UserFirstTime extends UserState {
  @override
  List<Object?> get props => [];
}

class UserRetrieveData extends UserState {
  final User user;

  const UserRetrieveData({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}
