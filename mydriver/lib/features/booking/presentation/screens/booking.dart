import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '/components/JCBFormTextField.dart'; // Import JCBFormTextField
import 'package:mydriver/features/booking/models/JCBSearchDestinationModel.dart'; // Import JCBSearchDestinationModel
import '../../logic/booking_controller.dart';
import '../../../auth/logic/auth_controller.dart';
import '/../../routes/app_routes.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  LatLng? _destination;
  Set<Polyline> _polylines = {};
  bool _isBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _getCurrentLocation();
  }

  void _checkLoginStatus() {
    final authController = Provider.of<AuthController>(context, listen: false);
    if (authController.currentUser == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied.'),
        ),
      );
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Update BookingController with the current position
    final bookingController = Provider.of<BookingController>(context, listen: false);
    bookingController.updatePosition(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    );
  }

  void _onDestinationSelected(LatLng destination) async {
    final bookingController = Provider.of<BookingController>(context, listen: false);
    setState(() {
      _destination = destination;
      _isBottomSheetVisible = true;
    });

    if (_currentPosition != null) {
      final polylinePoints = await bookingController.getRoute(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        destination,
      );

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: polylinePoints,
            color: Colors.red,
            width: 5,
          ),
        };

        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                _currentPosition!.latitude < destination.latitude
                    ? _currentPosition!.latitude
                    : destination.latitude,
                _currentPosition!.longitude < destination.longitude
                    ? _currentPosition!.longitude
                    : destination.longitude,
              ),
              northeast: LatLng(
                _currentPosition!.latitude > destination.latitude
                    ? _currentPosition!.latitude
                    : destination.latitude,
                _currentPosition!.longitude > destination.longitude
                    ? _currentPosition!.longitude
                    : destination.longitude,
              ),
            ),
            50,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: controller.currentPosition,
                  zoom: 12,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                  // Call BookingController's onMapCreated to add destination markers
                  Provider.of<BookingController>(context, listen: false).onMapCreated(controller);
                },
                polylines: _polylines,
                markers: {
                  ...controller.markers, // Include markers from BookingController (jcbDestinationsList)
                  if (_destination != null)
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: _destination!,
                    ),
                },
              ),
              Positioned(
                top: 50,
                left: 15,
                right: 15,
                child: SearchBar(onDestinationSelected: _onDestinationSelected),
              ),
              if (_isBottomSheetVisible)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: RideOptionsBottomSheet(
                    onBookNow: () {
                      // TODO: Implement booking logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ride booked successfully!')),
                      );
                      setState(() {
                        _isBottomSheetVisible = false;
                        _destination = null;
                        _polylines.clear();
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function(LatLng) onDestinationSelected;

  const SearchBar({super.key, required this.onDestinationSelected});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            JCBFormTextField(
              label: 'Where are you going?',
              textFieldType: TextFieldType.NAME, // Use NAME type for general text input
              controller: _controller,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                controller.searchPlaces(value); // Trigger search on text change
              },
            ),
            if (controller.searchResults.isNotEmpty)
              Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.searchResults.length,
                  itemBuilder: (context, index) {
                    final result = controller.searchResults[index];
                    return ListTile(
                      title: Text(result.name),
                      subtitle: Text(result.address),
                      onTap: () {
                        final location = LatLng(result.lat, result.lng);
                        widget.onDestinationSelected(location);
                        _controller.text = result.name;
                        controller.searchPlaces(''); // Clear search results
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class RideOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onBookNow;

  const RideOptionsBottomSheet({super.key, required this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'SUGGESTED RIDES',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          RideOptionTile(
            title: 'JUBERGO',
            price: '\$25.50',
            eta: '4 min',
            seats: '4 Seats',
          ),
          RideOptionTile(
            title: 'JUBERCAR',
            price: '\$35.00',
            eta: '5 min',
            seats: '4 Seats',
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cash payment', style: TextStyle(fontSize: 16)),
              TextButton(
                onPressed: () {
                  // TODO: Implement promo code logic
                },
                child: const Text('Promo'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onBookNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'BOOK NOW',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class RideOptionTile extends StatelessWidget {
  final String title;
  final String price;
  final String eta;
  final String seats;

  const RideOptionTile({
    super.key,
    required this.title,
    required this.price,
    required this.eta,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$eta • $seats'),
      trailing: Text(price, style: const TextStyle(fontSize: 16)),
      leading: const Icon(Icons.directions_car),
    );
  }
}