class Notification {
  late String emailAddress;
  late String notificationTitle;
  late String notificationDescription;
  late bool isSeen;
  late String dateSent;

  Notification({required this.emailAddress, required this.notificationTitle, required this.notificationDescription, required this.isSeen, required this.dateSent});

  Notification.fromJson(Map<String, dynamic> json) {
    emailAddress = json['email_address'] ?? '';
    notificationTitle = json['notification_title'] ?? '';
    notificationDescription = json['notification_description'] ?? '';
    isSeen = json['is_seen'] ?? false;
    dateSent = json['date_sent'];
  }
}