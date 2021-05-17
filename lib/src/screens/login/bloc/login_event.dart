import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  final String strEmail, strPassword;

  LoginEvent(this.strEmail, this.strPassword);

  @override
  List<Object> get props => [this.strEmail, this.strPassword];
}
