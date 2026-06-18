import 'package:booking_villa/data/models/booking.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingModel> bookings;

  BookingLoaded(this.bookings);
}

class BookingSuccess extends BookingState {
  final String message;

  BookingSuccess(this.message);
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}

class BookedDatesLoaded extends BookingState {
  final List<DateTime> disabledDates;
  BookedDatesLoaded(this.disabledDates);
}
