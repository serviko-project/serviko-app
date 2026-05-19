part of 'contact_directory_cubit.dart';

sealed class ContactDirectoryState extends Equatable {
  const ContactDirectoryState();

  @override
  List<Object?> get props => [];
}

class ContactDirectoryInitial extends ContactDirectoryState {
  const ContactDirectoryInitial();
}

class ContactDirectoryLoading extends ContactDirectoryState {
  const ContactDirectoryLoading();
}

class ContactDirectoryLoaded extends ContactDirectoryState {
  const ContactDirectoryLoaded(this.contacts);

  final List<ProviderDirectoryEntity> contacts;

  @override
  List<Object?> get props => [contacts];
}

class ContactDirectoryFailure extends ContactDirectoryState {
  const ContactDirectoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
