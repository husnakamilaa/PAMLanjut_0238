import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_villa/data/repositories/booking_repository.dart';

import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository repository;

  BookingBloc(this.repository)
      : super(BookingInitial()) {

    on<CreateBookingEvent>((event, emit) async {
      emit(BookingLoading());

      try {
        await repository.createBooking(
          event.booking,
        );

        emit(
          BookingSuccess(
            "Booking berhasil dibuat",
          ),
        );
      } catch (e) {
        emit(
          BookingError(
            e.toString(),
          ),
        );
      }
    });

    on<FetchAllBookingsEvent>((event, emit) async {
      emit(BookingLoading());

      try {
        final bookings =
            await repository.getAllBookingsAdmin();

        emit(
          BookingLoaded(bookings),
        );
      } catch (e) {
        emit(
          BookingError(
            e.toString(),
          ),
        );
      }
    });

    on<FetchMyBookingsEvent>((event, emit) async {
      emit(BookingLoading());

      try {
        final bookings =
            await repository.getMyBookings(
          event.customerId,
        );

        emit(
          BookingLoaded(bookings),
        );
      } catch (e) {
        emit(
          BookingError(
            e.toString(),
          ),
        );
      }
    });

    on<UpdateBookingStatusEvent>((event, emit) async {
      emit(BookingLoading());
      try {
        await repository.updateBookingStatus(
          event.bookingId,
          event.status,
        );

        emit(
          BookingSuccess(
            "Status booking diperbarui",
          ),
        );
      } catch (e) {
        emit(
          BookingError(
            e.toString(),
          ),
        );
      }
    });

    on<SaveInvoiceEvent>((event, emit) async {
      try {
        await repository.saveInvoice(
          event.bookingId,
          event.invoiceUrl,
          event.paymentMethod,
        );

        emit(
          BookingSuccess(
            "Invoice berhasil disimpan",
          ),
        );
      } catch (e) {
        emit(
          BookingError(
            e.toString(),
          ),
        );
      }
    });

    on<CancelBookingEvent>((event, emit) async {
      try {
        await repository.cancelBooking(
          event.bookingId,
        );

        emit(
          BookingSuccess(
            "Booking dibatalkan",
          ),
        );
      } catch (e) {
        emit(
          BookingError(
            e.toString(),
          ),
        );
      }
    });

  }
}