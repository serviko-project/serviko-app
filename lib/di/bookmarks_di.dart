import 'package:serviko_app/features/user/bookmarks/data/datasources/bookmark_remote_datasource.dart';
import 'package:serviko_app/features/user/bookmarks/data/repositories/bookmark_repository_impl.dart';
import 'package:serviko_app/features/user/bookmarks/domain/usecases/bookmark_service_usecase.dart';
import 'package:serviko_app/features/user/bookmarks/domain/usecases/unbookmark_service_usecase.dart';
import 'package:serviko_app/features/user/bookmarks/domain/usecases/get_bookmarks_usecase.dart';
import 'package:serviko_app/injection_container.dart';

extension BookmarksDI on InjectionContainer {
  void initBookmarks() {
    bookmarkRemoteDataSource = BookmarkRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    bookmarkRepository = BookmarkRepositoryImpl(
      remoteDataSource: bookmarkRemoteDataSource,
      networkInfo: networkInfo,
    );
    bookmarkServiceUseCase = BookmarkServiceUseCase(bookmarkRepository);
    unbookmarkServiceUseCase = UnbookmarkServiceUseCase(bookmarkRepository);
    getBookmarksUseCase = GetBookmarksUseCase(bookmarkRepository);
  }
}
