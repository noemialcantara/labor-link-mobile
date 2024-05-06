class Certification {
  late String fileName;
  late String link;
  late String emailAddress;
  
  
  Certification(this.fileName, this.link, this.emailAddress);


  Certification.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'] ?? '';
    link = json['link'] ?? '';
    emailAddress = json['email_address'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'file_name' : fileName,
      'link' : link,
      'email_address': emailAddress
    };
  }
}