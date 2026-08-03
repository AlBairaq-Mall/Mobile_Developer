import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class PickedLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class PickLocationSheet extends StatefulWidget {
  const PickLocationSheet({super.key});

  @override
  State<PickLocationSheet> createState() => _PickLocationSheetState();
}

class _PickLocationSheetState extends State<PickLocationSheet> {
  final MapController _controller = MapController();
  LatLng _center = const LatLng(
    15.369445,
    44.191007,
  );
  Future<void> _goToMyLocation() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) return;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    if (!mounted) return;

    setState(() {
      _center = LatLng(
        position.latitude,
        position.longitude,
      );
    });

    _controller.move(_center, 17);

    await _updateAddress();
  }

  String _address = "جارٍ تحديد الموقع...";

  bool _loading = false;
  bool _isClosing = false;

  Future<void> _updateAddress() async {
    if (!mounted || _isClosing) return;

    setState(() {
      _loading = true;
    });

    try {
      final place = await placemarkFromCoordinates(
        _center.latitude,
        _center.longitude,
      );

      if (!mounted || _isClosing) return;

      if (place.isNotEmpty) {
        final p = place.first;

        final address = [
          p.name,
          p.street,
          p.subLocality,
          p.locality,
          p.subAdministrativeArea,
          p.administrativeArea,
          p.country,
        ].where((e) => e != null && e.trim().isNotEmpty).join("، ");

        setState(() {
          _address = address;
        });
      }
    } catch (_) {
      if (!mounted || _isClosing) return;

      setState(() {
        _address = "تعذر تحديد العنوان";
      });
    } finally {
      if (mounted && !_isClosing) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _goToMyLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .78,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    _isClosing = true;
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close),
                ),
                const Expanded(
                  child: Text(
                    "اختيار الموقع",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    right: 15,
                    bottom: 110,
                    child: FloatingActionButton.small(
                      heroTag: "location",
                      onPressed: _goToMyLocation,
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Listener(
                      onPointerUp: (_) async {
                        await Future.delayed(
                          const Duration(milliseconds: 250),
                        );

                        _updateAddress();
                      },
                      child: FlutterMap(
                        mapController: _controller,
                        options: MapOptions(
                          initialCenter: _center,
                          initialZoom: 17,
                          onPositionChanged: (position, _) {
                            _center = position.center;
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName: "com.example.bhm_supermarket",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 20,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: "zoomIn",
                          onPressed: () async {
                            _controller.move(
                              _center,
                              _controller.camera.zoom + 1,
                            );
                          },
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(height: 8),
                        FloatingActionButton.small(
                          heroTag: "zoomOut",
                          onPressed: () async {
                            _controller.move(
                              _center,
                              _controller.camera.zoom - 1,
                            );
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),
                  IgnorePointer(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 46,
                              ),
                            )),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  if (_loading)
                    Container(
                      color: Colors.black12,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "العنوان",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_loading)
                    const LinearProgressIndicator()
                  else
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _address,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  SizedBox(
                      width: double.infinity,
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text(
                            "تأكيد الموقع",
                          ),
                          onPressed: (_loading || _isClosing)
                              ? null
                              : () {
                                  _isClosing = true;

                                  Navigator.of(context).pop(
                                    PickedLocation(
                                      latitude: _center.latitude,
                                      longitude: _center.longitude,
                                      address: _address,
                                    ),
                                  );
                                },
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
