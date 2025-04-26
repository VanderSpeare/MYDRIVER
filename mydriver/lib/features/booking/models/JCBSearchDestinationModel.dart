import 'googlePlaceIdModel.dart';

class JCBSearchDestinationModel {
  String name;
  String address;
  double lat; // Align with GooglePlaceIdModel
  double lng; // Align with GooglePlaceIdModel
  String? icon; // Optional: From GooglePlaceIdModel

  JCBSearchDestinationModel({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.icon,
  });

  // Factory method to create from GooglePlaceIdModel
  factory JCBSearchDestinationModel.fromGooglePlaceId(
    GooglePlaceIdModel place,
  ) {
    return JCBSearchDestinationModel(
      name: place.result?.vicinity ?? 'Unknown Place',
      address: place.result?.vicinity ?? 'Unknown Address',
      lat: place.result?.geometry?.location?.lat ?? 0.0,
      lng: place.result?.geometry?.location?.lng ?? 0.0,
      icon: place.result?.icon,
    );
  }
}

List<JCBSearchDestinationModel> jcbDestinationsList() {
  List<JCBSearchDestinationModel> list = [];

  list.add(
    JCBSearchDestinationModel(
      name: "Dinh Độc Lập (Independence Palace)",
      address: "135 Nam Kỳ Khởi Nghĩa, Bến Thành, Quận 1, TP. Hồ Chí Minh",
      lat: 10.7769,
      lng: 106.6953,
      icon: null,
    ),
  );
  list.add(
    JCBSearchDestinationModel(
      name: "Nhà Thờ Đức Bà Sài Gòn (Notre-Dame Basilica)",
      address: "Công xã Paris, Bến Nghé, Quận 1, TP. Hồ Chí Minh",
      lat: 10.7798,
      lng: 106.6990,
      icon: null,
    ),
  );
  list.add(
    JCBSearchDestinationModel(
      name: "Chợ Bến Thành",
      address: "Đường Lê Lợi, Bến Thành, Quận 1, TP. Hồ Chí Minh",
      lat: 10.7725,
      lng: 106.6981,
      icon: null,
    ),
  );
  list.add(
    JCBSearchDestinationModel(
      name: "Bảo tàng Chứng tích Chiến tranh",
      address: "28 Võ Văn Tần, Quận 3, TP. Hồ Chí Minh",
      lat: 10.7794,
      lng: 106.6820,
      icon: null,
    ),
  );
  list.add(
    JCBSearchDestinationModel(
      name: "Phố đi bộ Nguyễn Huệ",
      address: "Nguyễn Huệ, Bến Nghé, Quận 1, TP. Hồ Chí Minh",
      lat: 10.7747,
      lng: 106.7035,
      icon: null,
    ),
  );

  return list;
}
