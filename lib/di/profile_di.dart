import 'package:serviko_app/features/user/profile/data/datasources/profile_local_datasource.dart';
import 'package:serviko_app/features/user/profile/data/datasources/profile_remote_datasource.dart';
import 'package:serviko_app/features/user/profile/data/repositories/profile_repository_impl.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/create_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/delete_profile_image_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_cached_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/get_my_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/update_profile_usecase.dart';
import 'package:serviko_app/features/user/profile/domain/usecases/upload_profile_image_usecase.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize user profile dependencies
extension ProfileDI on InjectionContainer {
  void initProfile() {
    // Profile - Data
    profileLocalDataSource = ProfileLocalDataSourceImpl();
    profileRemoteDataSource = ProfileRemoteDataSourceImpl(apiClient: apiClient);
    userProfileRepository = UserUserProfileRepositoryImpl(
      remoteDataSource: profileRemoteDataSource,
      localDataSource: profileLocalDataSource,
      networkInfo: networkInfo,
    );

    // Profile - Use Cases
    createUserProfileUseCase = CreateUserProfileUseCase(userProfileRepository);
    getMyProfileUseCase = GetMyProfileUseCase(userProfileRepository);
    getCachedProfileUseCase = GetCachedProfileUseCase(userProfileRepository);
    updateProfileUseCase = UpdateProfileUseCase(userProfileRepository);
    uploadProfileImageUseCase = UploadProfileImageUseCase(
      userProfileRepository,
    );
    deleteProfileImageUseCase = DeleteProfileImageUseCase(
      userProfileRepository,
    );
  }
}
