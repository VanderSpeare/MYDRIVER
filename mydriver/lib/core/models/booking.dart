class Booking {
  final String id;
  final String customerId;
  final String? driverId;
  final String source;
  final String destination;
  final String vehicleType;
  String status;

  Booking({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.source,
    required this.destination,
    required this.vehicleType,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      customerId: json['customerId'],
      driverId: json['driverId'],
      source: json['source'],
      destination: json['destination'],
      vehicleType: json['vehicleType'],
      status: json['status'],
    );
  }
}