import 'package:booking_villa/data/models/booking.dart';

abstract class BookingEvent {}

class CreateBookingEvent extends BookingEvent {
  final BookingModel booking;

  CreateBookingEvent(this.booking);
}

class FetchAllBookingsEvent extends BookingEvent {}

class FetchMyBookingsEvent extends BookingEvent {
  final String customerId;

  FetchMyBookingsEvent(this.customerId);
}

class UpdateBookingStatusEvent extends BookingEvent {
  final String bookingId;
  final String status;

  UpdateBookingStatusEvent(
    this.bookingId,
    this.status,
  );
}

class SaveInvoiceEvent extends BookingEvent {
  final String bookingId;
  final String invoiceUrl;
  final String paymentMethod;

  SaveInvoiceEvent({
    required this.bookingId,
    required this.invoiceUrl,
    required this.paymentMethod,
  });
}

class CancelBookingEvent extends BookingEvent {
  final String bookingId;

  CancelBookingEvent(this.bookingId);
}