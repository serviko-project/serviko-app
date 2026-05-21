import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/usecases/usecase.dart';
import 'package:serviko_app/features/shared/communication/domain/entities/provider_directory_entity.dart';
import 'package:serviko_app/features/shared/communication/domain/usecases/get_provider_directory_usecase.dart';

part 'contact_directory_state.dart';

class ContactDirectoryCubit extends Cubit<ContactDirectoryState> {
  ContactDirectoryCubit({
    required GetProviderDirectoryUseCase getProviderDirectoryUseCase,
  }) : _getProviderDirectoryUseCase = getProviderDirectoryUseCase,
       super(const ContactDirectoryInitial());

  final GetProviderDirectoryUseCase _getProviderDirectoryUseCase;

  Future<void> fetchContacts() async {
    emit(const ContactDirectoryLoading());
    final result = await _getProviderDirectoryUseCase(const NoParams());
    result.fold(
      (failure) => emit(ContactDirectoryFailure(failure.message)),
      (contacts) => emit(ContactDirectoryLoaded(contacts)),
    );
  }
}
