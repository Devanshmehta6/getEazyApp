class FetchData {
  final String name;
  final String total;
  final String cp;
  final String direct;

  FetchData(
      {required this.cp,
      required this.direct,
      required this.name,
      required this.total});

  factory FetchData.fromJson(Map<String, dynamic> json) {
    //var obj = json[0];
    return FetchData(
        name: json['Name'],
        total: json['total_customers'],
        cp: json['cp_customers'],
        direct: json['direct_customers']);
  }
}
