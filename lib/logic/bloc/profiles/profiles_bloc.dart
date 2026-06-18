import 'package:booking_villa/data/repositories/profiles_repository.dart';
import 'package:booking_villa/logic/bloc/profiles/profiles_event.dart';
import 'package:booking_villa/logic/bloc/profiles/profiles_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.getUserProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}