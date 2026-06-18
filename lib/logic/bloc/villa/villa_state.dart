import 'package:booking_villa/data/models/villa.dart';

abstract class VillaState {}

class VillaInitial extends VillaState {}

class VillaLoading extends VillaState {}

class VillaLoaded extends VillaState {
  final List<VillaModel> villas;
  final bool isFilteredByDate;
  final List<DateTime> disabledDates;
  final bool hasMore;       
  final int currentPage;

  VillaLoaded(
    this.villas, {
      this.isFilteredByDate = false,
    this.disabledDates = const [],
    this.hasMore = true,   
    this.currentPage = 0,});
}

class VillaError extends VillaState {
  final String message;
  VillaError(this.message);
}

class VillaActionSuccess extends VillaState {
  final String message;
  VillaActionSuccess(this.message);
}