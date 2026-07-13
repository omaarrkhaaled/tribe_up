part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  const AuthState._({this.status = AuthStatus.unknown});

  const AuthState.unknown() : this._();
  const AuthState.authenticated() : this._(status: AuthStatus.authenticated);
  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status];
}
