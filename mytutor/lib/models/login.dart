class Login {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;

  Login({this.id, this.name, this.email, this.phone, this.address});

  Login.fromJson(Map<String, dynamic> json) {
    id = json['iuser_d'];
    name = json['user_name'];
    email = json['user_email'];
    phone = json['user_phone'];
    address = json['user_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = id;
    data['user_name'] = name;
    data['user_email'] = email;
    data['user_phone'] = phone;
    data['user_address'] = address;
    return data;
  }
}
