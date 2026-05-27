import '../../domain/entities/available_slots_entity.dart';

class AvailableSlotsModel extends AvailableSlotsEntity {
  const AvailableSlotsModel({
    required super.date,
    required super.providerId,
    required super.slots,
    super.allSlots,
    super.maxDurationFromSlot,
  });

  factory AvailableSlotsModel.fromJson(Map<String, dynamic> json) {
    final rawMap =
        json['max_duration_from_slot'] as Map<String, dynamic>? ?? {};
    final durationMap = rawMap.map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );

    return AvailableSlotsModel(
      date: json['date'] as String,
      providerId: json['provider_id'] as String,
      slots: List<String>.from(json['slots'] ?? []),
      allSlots: List<String>.from(json['all_slots'] ?? []),
      maxDurationFromSlot: durationMap,
    );
  }
}
