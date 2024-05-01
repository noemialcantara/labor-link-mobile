class Resume {
  late String fileName;
  late String link;
  late String profileJob;
  late String profileName;
  late String emailAddress;
  
  
  Resume(this.fileName, this.link, this.profileJob, this.profileName, this.emailAddress);


  Resume.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'] ?? '';
    link = json['link'] ?? '';
    profileJob = json['profile_job'] ?? '';
    profileName = json['profile_name'] ?? '';
    emailAddress = json['email_address'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'file_name' : fileName,
      'link' : link,
      'profile_job': profileJob,
      'profile_name': profileName,
      'email_address': emailAddress
    };
  }
}