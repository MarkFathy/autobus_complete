class DropDownModel {
  final int id;
  final String name;

  DropDownModel({required this.id, required this.name});

  factory DropDownModel.fromJson(Map<String, dynamic> json) => DropDownModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
