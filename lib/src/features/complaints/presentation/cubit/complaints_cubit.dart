import 'dart:async';
import 'package:autobus_complete/src/features/complaints/domain/entities/complaint_entity.dart';
import 'package:autobus_complete/src/features/complaints/domain/usecases/delete_complaint_usecase.dart';
import 'package:autobus_complete/src/features/complaints/domain/usecases/get_complaints_stream_usecase.dart';
import 'package:autobus_complete/src/features/complaints/domain/usecases/submit_complaint_usecase.dart';
import 'package:autobus_complete/src/features/complaints/presentation/cubit/complaints_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final SubmitComplaintUseCase submitComplaintUseCase;
  final GetComplaintsStreamUseCase getComplaintsStreamUseCase;
  final DeleteComplaintUseCase deleteComplaintUseCase;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  StreamSubscription<List<ComplaintEntity>>? _streamSubscription;

  ComplaintsCubit({
    required this.submitComplaintUseCase,
    required this.getComplaintsStreamUseCase,
    required this.deleteComplaintUseCase,
    required this.firebaseAuth,
    required this.firestore,
  }) : super(ComplaintsInitial());

  void listenToComplaints() {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      emit(ComplaintsEmpty());
      return;
    }

    emit(ComplaintsLoading());
    unawaited(_streamSubscription?.cancel());
    _streamSubscription = getComplaintsStreamUseCase(user.uid).listen(
      (complaints) {
        if (complaints.isEmpty) {
          emit(ComplaintsEmpty());
        } else {
          emit(ComplaintsLoaded(complaints));
        }
      },
      onError: (Object error) {
        emit(ComplaintsError(error.toString()));
      },
    );
  }

  Future<void> submit({required String type, required String title, required String message}) async {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      emit(const ComplaintsError('User not logged in'));
      return;
    }

    emit(ComplaintSubmitting());

    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    final userName = (userData?['name'] as String?)?.isNotEmpty ?? false
        ? userData!['name'] as String
        : (user.displayName ?? 'User');
    final userPhotoUrl = (userData != null && userData.containsKey('photoUrl'))
        ? userData['photoUrl'] as String?
        : user.photoURL;

    final entity = ComplaintEntity(
      id: '',
      userId: user.uid,
      userName: userName,
      userEmail: user.email ?? '',
      userPhoto: userPhotoUrl,
      type: type,
      title: title,
      message: message,
      status: 'pending',
      createdAt: DateTime.now(),
    );

    final result = await submitComplaintUseCase(entity);
    result.fold((failure) => emit(ComplaintsError(failure.serverException.message)), (_) {
      emit(ComplaintSubmitSuccess());
      // Resume listening to complaints list
      listenToComplaints();
    });
  }

  Future<void> deleteComplaint(String id) async {
    final result = await deleteComplaintUseCase(id);
    result.fold(
      (failure) => emit(ComplaintsError(failure.serverException.message)),
      (_) {
        // Stream will update list automatically
      },
    );
  }

  @override
  Future<void> close() {
    unawaited(_streamSubscription?.cancel());
    return super.close();
  }
}
