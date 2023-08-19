class SmsModel {
  final String id;
  final String receiver;
  final String meg;
  final String date;

  SmsModel(
      {required this.id,
      required this.receiver,
      required this.meg,
      required this.date});

  factory SmsModel.fromJson(Map<String, dynamic> map) {
    return SmsModel(
        id: map['id'],
        receiver: map['receiver'],
        meg: map['message'],
        date: map['date']);
  }
}
