import 'package:equatable/equatable.dart';

abstract class EditProviderDetailsState extends Equatable {
  const EditProviderDetailsState();

  @override
  List<Object?> get props => [];
}

class EditProviderDetailsInitial extends EditProviderDetailsState {}

class EditProviderDetailsLoading extends EditProviderDetailsState {}

class EditProviderDetailsSuccess extends EditProviderDetailsState {
  final String message;

  const EditProviderDetailsSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EditProviderDetailsError extends EditProviderDetailsState {
  final String message;

  const EditProviderDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class BannerImageUploadLoading extends EditProviderDetailsState {}

class BannerImageUploadSuccess extends EditProviderDetailsState {
  final String message;
  const BannerImageUploadSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BannerImageUploadError extends EditProviderDetailsState {
  final String message;
  const BannerImageUploadError(this.message);

  @override
  List<Object?> get props => [message];
}

class BannerImageDeleteLoading extends EditProviderDetailsState {}

class BannerImageDeleteSuccess extends EditProviderDetailsState {
  final String message;
  const BannerImageDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BannerImageDeleteError extends EditProviderDetailsState {
  final String message;
  const BannerImageDeleteError(this.message);

  @override
  List<Object?> get props => [message];
}
