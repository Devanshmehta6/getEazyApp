class User{
  final String name;
  final String username;
  final List<Address> address;

  User({required this.name , required this.username , required this.address});

  factory User.fromJson(Map<String , dynamic> json){
    return User(
      name : json['name'],
      username: json['username'],
      address: parseAddress(json),
    );
  }

  static List<Address> parseAddress(parsedJson){
    var list = parsedJson['address'] as List;
    List<Address> listAddress = list.map((data)=> Address.fromJson(data)).toList();
    return listAddress.toList();
  }
}

class Address{
  String street;
  String suite;

  Address({required this.street , required this.suite});

  factory Address.fromJson(Map<String , dynamic> json){
    return Address(street: json['street'] , suite: json['suite']);
  }
}
