import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';
import '../../domain/usecases/bookmark_service_usecase.dart';
import '../../domain/usecases/unbookmark_service_usecase.dart';
import '../../domain/usecases/get_bookmarks_usecase.dart';
import 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  final BookmarkServiceUseCase bookmarkServiceUseCase;
  final UnbookmarkServiceUseCase unbookmarkServiceUseCase;
  final GetBookmarksUseCase getBookmarksUseCase;

  BookmarksCubit({
    required this.bookmarkServiceUseCase,
    required this.unbookmarkServiceUseCase,
    required this.getBookmarksUseCase,
  }) : super(const BookmarksInitial());

  Future<void> fetchBookmarks() async {
    emit(const BookmarksLoading());

    final result = await getBookmarksUseCase(const GetBookmarksParams());
    result.fold((failure) => emit(BookmarksError(message: failure.message)), (
      bookmarks,
    ) {
      final bookmarkedIds = bookmarks.map((e) => e.id).toSet();
      emit(BookmarksLoaded(bookmarks: bookmarks, bookmarkedIds: bookmarkedIds));
    });
  }

  Future<void> toggleBookmark(ServiceEntity service) async {
    if (state is! BookmarksLoaded) {
      await fetchBookmarks();
      if (state is! BookmarksLoaded) return;
    }

    final currentState = state as BookmarksLoaded;
    final isCurrentlyBookmarked = currentState.bookmarkedIds.contains(
      service.id,
    );

    final updatedIds = Set<String>.from(currentState.bookmarkedIds);
    final updatedList = List<ServiceEntity>.from(currentState.bookmarks);

    if (isCurrentlyBookmarked) {
      updatedIds.remove(service.id);
      updatedList.removeWhere((e) => e.id == service.id);
      emit(BookmarksLoaded(bookmarks: updatedList, bookmarkedIds: updatedIds));

      final result = await unbookmarkServiceUseCase(
        UnbookmarkParams(serviceId: service.id),
      );

      result.fold((failure) {
        final rollbackIds = Set<String>.from(currentState.bookmarkedIds);
        final rollbackList = List<ServiceEntity>.from(currentState.bookmarks);
        emit(
          BookmarksLoaded(bookmarks: rollbackList, bookmarkedIds: rollbackIds),
        );
      }, (_) => null);
    } else {
      updatedIds.add(service.id);
      updatedList.add(service);
      emit(BookmarksLoaded(bookmarks: updatedList, bookmarkedIds: updatedIds));

      final result = await bookmarkServiceUseCase(
        BookmarkParams(serviceId: service.id),
      );

      result.fold((failure) {
        final rollbackIds = Set<String>.from(currentState.bookmarkedIds);
        final rollbackList = List<ServiceEntity>.from(currentState.bookmarks);
        emit(
          BookmarksLoaded(bookmarks: rollbackList, bookmarkedIds: rollbackIds),
        );
      }, (_) => null);
    }
  }

  bool isBookmarked(String serviceId) {
    if (state is BookmarksLoaded) {
      return (state as BookmarksLoaded).bookmarkedIds.contains(serviceId);
    }
    return false;
  }
}
