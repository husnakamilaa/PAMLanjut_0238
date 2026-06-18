import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:booking_villa/data/repositories/villa_repository.dart';
import 'villa_event.dart';
import 'villa_state.dart';

class VillaBloc extends Bloc<VillaEvent, VillaState> {
  final VillaRepository repository;

  VillaBloc({required this.repository}) : super(VillaInitial()) {
    const int _pageSize = 10;

    on<FetchAllVillas>((event, emit) async {
      emit(VillaLoading());
      try {
        final villas = await repository.getAllVillas(
          onlyAvailable: event.onlyAvailable,
          page: 0,
          pageSize: _pageSize,
        );
        emit(
          VillaLoaded(
            villas,
            hasMore: villas.length == _pageSize,
            currentPage: 0,
          ),
        );
      } catch (e) {
        emit(VillaError("Gagal mengambil data: $e"));
      }
    });

    on<LoadMoreVillas>((event, emit) async {
      final current = state;
      if (current is! VillaLoaded || !current.hasMore) return; 

      try {
        final nextPage = current.currentPage + 1;
        final more = await repository.getAllVillas(
          page: nextPage,
          pageSize: _pageSize,
        );
        emit(
          VillaLoaded(
            [...current.villas, ...more],
            currentPage: nextPage,
            hasMore: more.length == _pageSize,
          ),
        );
      } catch (e) {
        emit(VillaError("Gagal load more: $e"));
      }
    });

    on<SearchVillaEvent>((event, emit) async {
      emit(VillaLoading());
      try {
        final villas = await repository.searchVilla(event.query);
        emit(VillaLoaded(villas));
      } catch (e) {
        emit(VillaError("Pencarian gagal: $e"));
      }
    });

    on<SearchAvailableVillaEvent>((event, emit) async {
      emit(VillaLoading());

      try {
        final villas = await repository.searchAvailableVilla(
          query: event.query,
          checkIn: event.checkIn,
          checkOut: event.checkOut,
        );

        emit(VillaLoaded(villas, isFilteredByDate: true));
      } catch (e) {
        emit(VillaError(e.toString()));
      }
    });

    on<FilterVillaStatusEvent>((event, emit) async {
      emit(VillaLoading());
      try {
        if (event.status == 'All') {
          final villas = await repository.getAllVillas();
          emit(VillaLoaded(villas));
        } else {
          final villas = await repository.filterByStatus(event.status);
          emit(VillaLoaded(villas));
        }
      } catch (e) {
        emit(VillaError("Filter gagal: $e"));
      }
    });


    on<AddVillaEvent>((event, emit) async {
      emit(VillaLoading());
      try {
        await repository.addVilla(event.villa);
        emit(VillaActionSuccess("Villa berhasil ditambahkan"));
        add(FetchAllVillas());
      } catch (e) {
        emit(VillaError("Gagal menambah villa: $e"));
      }
    });

    on<UpdateVillaEvent>((event, emit) async {
      try {
        await repository.updateVilla(event.id, event.villa);
        emit(VillaActionSuccess("Villa berhasil diperbarui"));
      } catch (e) {
        emit(VillaError("Gagal update villa: $e"));
      }
    });

    on<DeleteVillaEvent>((event, emit) async {
      try {
        await repository.deleteVilla(event.id);
        add(FetchAllVillas());
      } catch (e) {
        emit(VillaError("Gagal menghapus villa: $e"));
      }
    });
  }
}
