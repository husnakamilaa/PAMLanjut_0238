  import 'package:booking_villa/data/models/villa.dart';

  abstract class VillaEvent {}

  class FetchAllVillas extends VillaEvent {
    final bool onlyAvailable;
    FetchAllVillas({this.onlyAvailable = true}); 
  }

  class LoadMoreVillas extends VillaEvent {}

  class SearchVillaEvent extends VillaEvent {
    final String query;
    SearchVillaEvent(this.query);
  }

  class SearchAvailableVillaEvent extends VillaEvent {
    final String query;
    final DateTime checkIn;
    final DateTime checkOut;

    SearchAvailableVillaEvent({
      required this.query,
      required this.checkIn,
      required this.checkOut,
    });
  }

  // class FetchBookedDatesEvent extends VillaEvent {
  //   final String villaId;
  //   FetchBookedDatesEvent(this.villaId);
  // }


  class FilterVillaStatusEvent extends VillaEvent {
    final String status;
    FilterVillaStatusEvent(this.status);
  }

  class AddVillaEvent extends VillaEvent {
    final VillaModel villa;
    AddVillaEvent(this.villa);
  }

  class UpdateVillaEvent extends VillaEvent {
    final int id;
    final VillaModel villa;
    UpdateVillaEvent(this.id, this.villa);
  }

  class DeleteVillaEvent extends VillaEvent {
    final int id;
    DeleteVillaEvent(this.id);
  }