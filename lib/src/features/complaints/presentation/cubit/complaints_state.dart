import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ComplaintsState extends Equatable {
  const ComplaintsState();

  @override
  List<Object?> get props => [];
}

class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

class ComplaintsLoaded extends ComplaintsState {
  final List<ComplaintEntity> complaints;

  const ComplaintsLoaded(this.complaints);

  @override
  List<Object?> get props => [complaints];
}

class ComplaintsEmpty extends ComplaintsState {}

class ComplaintsRefreshing extends ComplaintsState {
  final List<ComplaintEntity> currentComplaints;

  const ComplaintsRefreshing(this.currentComplaints);

  @override
  List<Object?> get props => [currentComplaints];
}

class ComplaintsError extends ComplaintsState {
  final String message;

  const ComplaintsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ComplaintSubmitting extends ComplaintsState {}

class ComplaintSubmitSuccess extends ComplaintsState {}
