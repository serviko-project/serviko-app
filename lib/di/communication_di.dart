import 'package:serviko_app/features/shared/communication/data/datasources/zego_remote_datasource.dart';
import 'package:serviko_app/features/shared/communication/data/repositories/communication_repository_impl.dart';
import 'package:serviko_app/features/shared/communication/domain/usecases/get_provider_directory_usecase.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_service.dart';
import 'package:serviko_app/features/shared/communication/zego/zego_token_manager.dart';
import 'package:serviko_app/injection_container.dart';

// Extension to modularize communication dependencies
extension CommunicationDI on InjectionContainer {
  void initCommunication() {
    zegoRemoteDataSource = ZegoRemoteDataSourceImpl(apiClient: apiClient);
    communicationRepository = CommunicationRepositoryImpl(
      remoteDataSource: zegoRemoteDataSource,
      networkInfo: networkInfo,
    );
    getProviderDirectoryUseCase = GetProviderDirectoryUseCase(
      communicationRepository,
    );
    zegoTokenManager = ZegoTokenManager(communicationRepository);
    zegoService = ZegoService(tokenManager: zegoTokenManager);
  }
}
