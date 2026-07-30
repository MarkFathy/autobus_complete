import 'package:autobus_complete/src/features/settings/domain/entities/app_info_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AppInfoState extends Equatable {
  const AppInfoState();

  @override
  List<Object?> get props => [];
}

class AppInfoInitial extends AppInfoState {}

class AppInfoLoading extends AppInfoState {}

class AppInfoLoaded extends AppInfoState {
  final AppInfoEntity info;

  const AppInfoLoaded(this.info);

  @override
  List<Object?> get props => [info];
}

class AppInfoError extends AppInfoState {
  final String message;

  const AppInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
