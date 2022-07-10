class Cart {
  String? cartid;
  String? subjectName;
  String? subjectPrice;
  String? subjectId;
  String? cartqty;
  String? pricetotal;
  String? cartstatus;

  Cart({
    this.cartid,
    this.subjectName,
    this.subjectPrice,
    this.subjectId,
    this.pricetotal,
    this.cartstatus,
    this.cartqty,
  });

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    subjectName = json['subjectName'];
    subjectPrice = json['subjectPrice'];
    subjectId = json['subjectId'];
    cartqty = json['cartqty'];
    pricetotal = json['pricetotal'];
    cartstatus = json['cartstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['subjectName'] = subjectName;
    data['subjectPrice'] = subjectPrice;
    data['subjectId'] = subjectId;
    data['cartqty'] = cartqty;
    data['pricetotal'] = pricetotal;
    data['cartstatus'] = cartstatus;

    return data;
  }
}
