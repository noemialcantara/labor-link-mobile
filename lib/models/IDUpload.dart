class IDUpload {
  late String fileName;
  late String link;
  late String emailAddress;
  late String idType;
  
  IDUpload(this.fileName, this.link, this.emailAddress, this.idType);


  IDUpload.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'] ?? '';
    link = json['link'] ?? '';
    idType = json['id_type'] ?? '';
    emailAddress = json['email_address'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'file_name' : fileName,
      'link' : link,
      'id_type': idType,
      'email_address': emailAddress
    };
  }
}