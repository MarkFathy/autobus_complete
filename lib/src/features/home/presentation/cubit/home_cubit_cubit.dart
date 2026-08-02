import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_cubit_state.dart';

class HomeCubitCubit extends Cubit<HomeCubitState> {
  HomeCubitCubit() : super(HomeCubitInitial());
}
