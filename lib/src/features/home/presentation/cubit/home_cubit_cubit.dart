import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_cubit_state.dart';

class HomeCubitCubit extends Cubit<HomeCubitState> {
  HomeCubitCubit() : super(HomeCubitInitial());
}
