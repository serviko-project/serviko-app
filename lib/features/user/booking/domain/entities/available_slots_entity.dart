import 'package:equatable/equatable.dart';

class AvailableSlotsEntity extends Equatable {
  final String date;
  final String providerId;
  final List<String> slots;
  final List<String> allSlots;
  final Map<String, int> maxDurationFromSlot;

  const AvailableSlotsEntity({
    required this.date,
    required this.providerId,
    required this.slots,
    this.allSlots = const [],
    this.maxDurationFromSlot = const {},
  });

  bool get isProviderAvailable => slots.isNotEmpty;

  @override
  List<Object?> get props => [
    date,
    providerId,
    slots,
    allSlots,
    maxDurationFromSlot,
  ];
}
