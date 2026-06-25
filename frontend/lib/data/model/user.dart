class PsychUser {
  PsychUser({
    required this.uid,
    required this.email,
    required this.token,
    required this.displayName,
    this.phoneNumber,
    this.photoUrl,

    this.emergencyName,
    this.emergencyPhone,
  });

  factory PsychUser.fromJson(Map<String, dynamic> json) => PsychUser(
    uid: json['uid'],
    email: json['email'],
    displayName: json['display_name'],
    phoneNumber: json['phone_number'],
    photoUrl: json['photo_url'],
    token: json['id_token'],

    emergencyName: json['emergency_name'],
    emergencyPhone: json['emergency_phone'],
  );

  String uid;
  String email;
  String displayName;
  String? phoneNumber;
  String? photoUrl;
  String? token;

  String? emergencyName;
  String? emergencyPhone;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'display_name': displayName,
    'phone_number': phoneNumber,
    'photo_url': photoUrl,
    'id_token': token,

    'emergency_name': emergencyName,
    'emergency_phone': emergencyPhone,
  };
}