import 'package:serviko_app/features/user/category/data/datasources/category_remote_data_source.dart';
import 'package:serviko_app/features/user/category/data/repositories/category_repository_impl.dart';
import 'package:serviko_app/features/user/category/domain/usecases/get_categories_usecase.dart'
    as user_category;
import 'package:serviko_app/features/user/service/data/datasources/service_remote_data_source.dart';
import 'package:serviko_app/features/user/service/data/repositories/service_repository_impl.dart';
import 'package:serviko_app/features/user/service/domain/usecases/get_popular_services_usecase.dart';
import 'package:serviko_app/features/user/service/domain/usecases/get_service_detail_usecase.dart';
import 'package:serviko_app/features/user/search/data/datasources/search_remote_data_source.dart';
import 'package:serviko_app/features/user/search/data/datasources/search_local_datasource.dart';
import 'package:serviko_app/features/user/search/data/repositories/search_repository_impl.dart';
import 'package:serviko_app/features/user/search/domain/usecases/search_services_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/get_price_range_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/get_recent_searches_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/save_recent_search_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/remove_recent_search_usecase.dart';
import 'package:serviko_app/features/user/search/domain/usecases/clear_recent_searches_usecase.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize user services/categories/search dependencies
extension ServicesDI on InjectionContainer {
  void initServices() {
    // User Category
    categoryRemoteDataSource = CategoryRemoteDataSourceImpl(
      apiClient: apiClient,
    );
    categoryRepository = CategoryRepositoryImpl(
      remoteDataSource: categoryRemoteDataSource,
      networkInfo: networkInfo,
    );
    userGetCategoriesUseCase = user_category.GetCategoriesUseCase(
      categoryRepository,
    );

    // User Service
    serviceRemoteDataSource = ServiceRemoteDataSourceImpl(apiClient: apiClient);
    serviceRepository = ServiceRepositoryImpl(
      remoteDataSource: serviceRemoteDataSource,
      networkInfo: networkInfo,
    );
    getPopularServicesUseCase = GetPopularServicesUseCase(serviceRepository);
    getServiceDetailUseCase = GetServiceDetailUseCase(serviceRepository);

    // Search
    searchRemoteDataSource = SearchRemoteDataSourceImpl(apiClient: apiClient);
    searchLocalDataSource = SearchLocalDataSourceImpl();
    searchRepository = SearchRepositoryImpl(
      remoteDataSource: searchRemoteDataSource,
      localDataSource: searchLocalDataSource,
      networkInfo: networkInfo,
    );
    searchServicesUseCase = SearchServicesUseCase(searchRepository);
    getPriceRangeUseCase = GetPriceRangeUseCase(searchRepository);
    getRecentSearchesUseCase = GetRecentSearchesUseCase(searchRepository);
    saveRecentSearchUseCase = SaveRecentSearchUseCase(searchRepository);
    removeRecentSearchUseCase = RemoveRecentSearchUseCase(searchRepository);
    clearRecentSearchesUseCase = ClearRecentSearchesUseCase(searchRepository);
  }
}
