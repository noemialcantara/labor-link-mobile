class IDUpload {
  late String fileName;
  late String link;
  late String emailAddress;
  late String idType;
  late String userType;

  IDUpload(
      this.fileName, this.link, this.emailAddress, this.idType, this.userType);

  IDUpload.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'] ?? '';
    link = json['link'] ?? '';
    idType = json['id_type'] ?? '';
    emailAddress = json['email_address'] ?? '';
    userType = json['user_type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'file_name': fileName,
      'link': link,
      'id_type': idType,
      'email_address': emailAddress,
      'user_type': userType
    };
  }
}
