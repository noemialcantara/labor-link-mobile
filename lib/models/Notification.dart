class Notification {
  late String id;
  late String emailAddress;
  late String notificationTitle;
  late String notificationDescription;
  late bool isSeen;
  late String dateSent;

  Notification({required this.id, required this.emailAddress, required this.notificationTitle, required this.notificationDescription, required this.isSeen, required this.dateSent});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    emailAddress = json['email_address'] ?? '';
    notificationTitle = json['notification_title'] ?? '';
    notificationDescription = json['notification_description'] ?? '';
    isSeen = json['is_seen'] ?? false;
    dateSent = json['date_sent'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'email_address' : emailAddress,
      'notification_title': notificationTitle,
      'notification_description': notificationDescription,
      'is_seen': isSeen,
      'date_sent': dateSent
    };
  }
}