import 'package:equatable/equatable.dart';

// State for service detail screen
class ServiceDetailState extends Equatable {
  final int? selectedRating;
  final bool isAboutExpanded;

  const ServiceDetailState({this.selectedRating, this.isAboutExpanded = false});

  ServiceDetailState copyWith({
    int? Function()? selectedRating,
    bool? isAboutExpanded,
  }) {
    return ServiceDetailState(
      selectedRating: selectedRating != null
          ? selectedRating()
          : this.selectedRating,
      isAboutExpanded: isAboutExpanded ?? this.isAboutExpanded,
    );
  }

  @override
  List<Object?> get props => [selectedRating, isAboutExpanded];
}
