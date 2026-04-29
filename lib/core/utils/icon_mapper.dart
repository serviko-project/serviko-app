import 'package:flutter/material.dart';

// Maps Icon Name to IconData and vice versa
abstract final class IconMapper {
  static const Map<String, IconData> _nameToIcon = {
    'home_rounded': Icons.home_rounded,
    'palette_rounded': Icons.palette_rounded,
    'camera_alt_rounded': Icons.camera_alt_rounded,
    'spa_rounded': Icons.spa_rounded,
    'fitness_center_rounded': Icons.fitness_center_rounded,
    'fastfood_rounded': Icons.fastfood_rounded,
    'shopping_bag_rounded': Icons.shopping_bag_rounded,
    'medical_services_rounded': Icons.medical_services_rounded,
    'chair_rounded': Icons.chair_rounded,
    'park_rounded': Icons.park_rounded,
    'electrical_services_rounded': Icons.electrical_services_rounded,
    'flash_on_rounded': Icons.flash_on_rounded,
    'plumbing_rounded': Icons.plumbing_rounded,
    'water_drop_rounded': Icons.water_drop_rounded,
    'ac_unit_rounded': Icons.ac_unit_rounded,
    'hvac_rounded': Icons.hvac_rounded,
    'cleaning_services_rounded': Icons.cleaning_services_rounded,
    'local_laundry_service_rounded': Icons.local_laundry_service_rounded,
    'dry_cleaning_rounded': Icons.dry_cleaning_rounded,
    'build_rounded': Icons.build_rounded,
    'handyman_rounded': Icons.handyman_rounded,
    'home_repair_service_rounded': Icons.home_repair_service_rounded,
    'format_paint_rounded': Icons.format_paint_rounded,
    'local_shipping_rounded': Icons.local_shipping_rounded,
    'inventory_2_rounded': Icons.inventory_2_rounded,
    'yard_rounded': Icons.yard_rounded,
    'computer_rounded': Icons.computer_rounded,
    'phone_iphone_rounded': Icons.phone_iphone_rounded,
    'directions_car_rounded': Icons.directions_car_rounded,
    'car_repair_rounded': Icons.car_repair_rounded,
    'iron_rounded': Icons.iron_rounded,
    'kitchen_rounded': Icons.kitchen_rounded,
    'security_rounded': Icons.security_rounded,
    'pets_rounded': Icons.pets_rounded,
    'engineering_rounded': Icons.engineering_rounded,
    'category_rounded': Icons.category_rounded,
    'pest_control_rounded': Icons.pest_control_rounded,
    'roofing_rounded': Icons.roofing_rounded,
    'design_services_rounded': Icons.design_services_rounded,
    'child_care_rounded': Icons.child_care_rounded,
    'power_rounded': Icons.power_rounded,
    'solar_power_rounded': Icons.solar_power_rounded,
    'landscape_rounded': Icons.landscape_rounded,
    'eco_rounded': Icons.eco_rounded,
    'content_cut_rounded': Icons.content_cut_rounded,
    'delivery_dining_rounded': Icons.delivery_dining_rounded,
    'sanitizer_rounded': Icons.sanitizer_rounded,
    'moving_rounded': Icons.moving_rounded,
  };

  // Get all available icons
  static List<IconData> get availableIcons => _nameToIcon.values.toList();

  // Create reverse mapping for IconData to name
  static final Map<int, String> _codePointToName = {
    for (final entry in _nameToIcon.entries) entry.value.codePoint: entry.key,
  };

  // Convert icon name string to IconData
  static IconData fromName(String name) {
    return _nameToIcon[name] ?? Icons.category_rounded;
  }

  // Convert IconData to its corresponding name string
  static String toName(IconData icon) {
    return _codePointToName[icon.codePoint] ?? 'category_rounded';
  }
}
