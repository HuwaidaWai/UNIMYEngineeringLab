class LabBookingModel {
  String? id;
  String? room;
  String? date;
  String? slot;
  String? userId;

  LabBookingModel({this.id, this.room, this.date, this.slot, this.userId});

  factory LabBookingModel.fromJson(Map<String, dynamic> json) {
    return LabBookingModel(
        id: json['id'],
        room: json['room'],
        date: json['date'],
        slot: json['slot'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room': room,
      'date': date,
      'slot': slot,
      'userId': userId
    };
  }
}
