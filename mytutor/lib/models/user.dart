class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? address;
  String? cart;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.phone,
      this.address,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['pass'];
    phone = json['phone'];
    address = json['address'];
    cart = json['cart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['pass'] = password;
    data['phone'] = phone;
    data['address'] = address;
    data['cart'] = cart;
    return data;
  }
}
