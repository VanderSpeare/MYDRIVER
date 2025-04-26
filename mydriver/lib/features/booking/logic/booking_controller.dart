import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/JCBSearchDestinationModel.dart';
import '../models/googlePlaceIdModel.dart';

class BookingController with ChangeNotifier {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(
    10.7769,
    106.7009,
  ); // Default: Ho Chi Minh City
  Set<Marker> _markers = {};
  final String apiKey =
      'AIzaSyBBXirXXAoUFVwM63jvVKm9XoclKlodCbs'; // Replace with your Google API key
  List<JCBSearchDestinationModel> _searchResults = [];
  List<JCBSearchDestinationModel> _destinations = jcbDestinationsList();

  LatLng get currentPosition => _currentPosition;
  Set<Marker> get markers => _markers;
  List<JCBSearchDestinationModel> get searchResults => _searchResults;
  List<JCBSearchDestinationModel> get destinations => _destinations;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Add markers for destinations
    _addDestinationMarkers();
    notifyListeners();
  }

  void _addDestinationMarkers() {
    _markers.clear();
    for (var destination in _destinations) {
      _markers.add(
        Marker(
          markerId: MarkerId(destination.name),
          position: LatLng(destination.lat, destination.lng),
          infoWindow: InfoWindow(
            title: destination.name,
            snippet: destination.address,
          ),
        ),
      );
    }
  }

  Future<void> updatePosition(LatLng newPosition) async {
    _currentPosition = newPosition;
    _markers.add(
      Marker(
        markerId: const MarkerId('current_position'),
        position: newPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    _mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
    notifyListeners();
  }

  Future<void> searchPlaces(String input) async {
    _searchResults =
        _destinations
            .where(
              (destination) =>
                  destination.name.toLowerCase().contains(
                    input.toLowerCase(),
                  ) ||
                  destination.address.toLowerCase().contains(
                    input.toLowerCase(),
                  ),
            )
            .toList();

    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&language=vi&components=country:VN';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          for (var prediction in data['predictions']) {
            final placeId = prediction['place_id'];
            final placeDetails = await _fetchPlaceDetails(placeId);
            if (placeDetails != null) {
              _searchResults.add(
                JCBSearchDestinationModel.fromGooglePlaceId(placeDetails),
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error searching places: $e');
    }
    notifyListeners();
  }

  Future<GooglePlaceIdModel?> _fetchPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&language=vi';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GooglePlaceIdModel.fromJson(data);
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
    return null;
  }

  Future<LatLng?> getPlaceLocation(String placeId) async {
    final placeDetails = await _fetchPlaceDetails(placeId);
    if (placeDetails != null &&
        placeDetails.result?.geometry?.location != null) {
      return LatLng(
        placeDetails.result!.geometry!.location!.lat!,
        placeDetails.result!.geometry!.location!.lng!,
      );
    }
    return null;
  }

  Future<List<LatLng>> getRoute(LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          final polyline = data['routes'][0]['overview_polyline']['points'];
          return _decodePolyline(polyline);
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
    return [];
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void dispose() {
    _mapController?.dispose();
  }
}
