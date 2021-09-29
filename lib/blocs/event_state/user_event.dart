import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserCheckFirstTime extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UserReRetrieveData extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UserStoreData extends UserEvent {
  final String name;

  const UserStoreData({required this.name});

  @override
  List<Object?> get props => [name];
}
