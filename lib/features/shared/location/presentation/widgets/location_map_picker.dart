import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serviko_app/core/constants/app_colors.dart';
import '../cubit/location_map_cubit.dart';

// Map with draggable pin and radius circle overlay
class LocationMapPicker extends StatefulWidget {
  final LatLng center;
  final double radiusKm;
  final bool isDraggable;
  final ValueChanged<LatLng>? onLocationChanged;
  final double? height;

  const LocationMapPicker({
    super.key,
    required this.center,
    this.radiusKm = 15.0,
    this.isDraggable = true,
    this.onLocationChanged,
    this.height = 220,
  });

  @override
  State<LocationMapPicker> createState() => _LocationMapPickerState();
}

class _LocationMapPickerState extends State<LocationMapPicker> {
  late final MapController _mapController;
  late final LocationMapCubit _locationMapCubit;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _locationMapCubit = LocationMapCubit(widget.center);
  }

  @override
  void didUpdateWidget(covariant LocationMapPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.center != widget.center) {
      _locationMapCubit.updatePin(widget.center);
      _mapController.move(widget.center, _mapController.camera.zoom);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _locationMapCubit.close();
    super.dispose();
  }

  // Calculate zoom level based on radius
  double _zoomForRadius(double radiusKm) {
    if (radiusKm <= 2) return 14.0;
    if (radiusKm <= 5) return 12.5;
    if (radiusKm <= 10) return 11.5;
    if (radiusKm <= 20) return 10.5;
    if (radiusKm <= 35) return 9.5;
    return 8.5;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _locationMapCubit,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: BlocBuilder<LocationMapCubit, LatLng>(
            builder: (context, currentPin) {
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentPin,
                  initialZoom: _zoomForRadius(widget.radiusKm),
                  onTap: widget.isDraggable
                      ? (tapPosition, point) {
                          context.read<LocationMapCubit>().updatePin(point);
                          widget.onLocationChanged?.call(point);
                        }
                      : null,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  // OSM Tile Layer
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.serviko.serviko_app',
                  ),

                  // Radius circle overlay
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: currentPin,
                        radius: widget.radiusKm * 1000,
                        useRadiusInMeter: true,
                        color: AppColors.primary.withAlpha(25),
                        borderColor: AppColors.primary.withAlpha(120),
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),

                  // Pin marker
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentPin,
                        width: 40,
                        height: 40,
                        alignment: Alignment.topCenter,
                        child: const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
