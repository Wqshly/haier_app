import 'package:equatable/equatable.dart';

class User extends Equatable {

  const User({
    required this.id,
    this.username,
    this.password,
  });

  final int id;

  final String? username;

  final String? password;

  @override
  // TODO: implement props
  List<Object?> get props => [id, username, password];
}