import 'package:equatable/equatable.dart';
import 'package:serviko_app/features/user/service/domain/entities/service_entity.dart';

abstract class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object?> get props => [];
}

class BookmarksInitial extends BookmarksState {
  const BookmarksInitial();
}

class BookmarksLoading extends BookmarksState {
  const BookmarksLoading();
}

class BookmarksLoaded extends BookmarksState {
  final List<ServiceEntity> bookmarks;
  final Set<String> bookmarkedIds;

  const BookmarksLoaded({required this.bookmarks, required this.bookmarkedIds});

  @override
  List<Object?> get props => [bookmarks, bookmarkedIds];

  BookmarksLoaded copyWith({
    List<ServiceEntity>? bookmarks,
    Set<String>? bookmarkedIds,
  }) {
    return BookmarksLoaded(
      bookmarks: bookmarks ?? this.bookmarks,
      bookmarkedIds: bookmarkedIds ?? this.bookmarkedIds,
    );
  }
}

class BookmarksError extends BookmarksState {
  final String message;

  const BookmarksError({required this.message});

  @override
  List<Object?> get props => [message];
}
