import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/medicine_models.dart';
import '../../data/repositories/medicines_repository.dart';

typedef MedicinesQuery = ({String searchTerm, int pageNumber, int pageSize});

class MedicinesListState {
  const MedicinesListState({
    this.items = const [],
    this.pageNumber = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  final List<Medicine> items;
  final int pageNumber;
  final int totalPages;
  final int totalCount;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  bool get hasNextPage => pageNumber < totalPages;

  MedicinesListState copyWith({
    List<Medicine>? items,
    int? pageNumber,
    int? totalPages,
    int? totalCount,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
  }) => MedicinesListState(
    items: items ?? this.items,
    pageNumber: pageNumber ?? this.pageNumber,
    totalPages: totalPages ?? this.totalPages,
    totalCount: totalCount ?? this.totalCount,
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: error,
  );
}

class MedicinesListNotifier extends StateNotifier<MedicinesListState> {
  MedicinesListNotifier(this._repository) : super(const MedicinesListState());

  final MedicinesRepository _repository;
  String _searchTerm = '';
  static const _pageSize = 20;

  Future<void> loadInitial(String searchTerm) async {
    _searchTerm = searchTerm;
    state = const MedicinesListState(isLoading: true);
    try {
      final page = await _repository.getMedicines(
        searchTerm: searchTerm,
        pageNumber: 1,
        pageSize: _pageSize,
      );
      state = MedicinesListState(
        items: page.items,
        pageNumber: page.pageNumber,
        totalPages: page.totalPages,
        totalCount: page.totalCount,
      );
    } catch (e) {
      state = MedicinesListState(error: '$e');
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNextPage) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final page = await _repository.getMedicines(
        searchTerm: _searchTerm,
        pageNumber: state.pageNumber + 1,
        pageSize: _pageSize,
      );
      state = state.copyWith(
        items: [...state.items, ...page.items],
        pageNumber: page.pageNumber,
        totalPages: page.totalPages,
        totalCount: page.totalCount,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: '$e');
    }
  }

  Future<void> refresh() async => loadInitial(_searchTerm);
}

final medicinesListProvider =
    StateNotifierProvider.autoDispose<MedicinesListNotifier, MedicinesListState>(
      (ref) => MedicinesListNotifier(ref.watch(medicinesRepositoryProvider))
        ..loadInitial(''),
    );

final medicinesProvider = FutureProvider.autoDispose
    .family<MedicinePage, MedicinesQuery>(
      (ref, query) => ref
          .watch(medicinesRepositoryProvider)
          .getMedicines(
            searchTerm: query.searchTerm,
            pageNumber: query.pageNumber,
            pageSize: query.pageSize,
          ),
    );

final medicineDetailsProvider = FutureProvider.autoDispose
    .family<Medicine, String>(
      (ref, id) => ref.watch(medicinesRepositoryProvider).getMedicine(id),
    );
