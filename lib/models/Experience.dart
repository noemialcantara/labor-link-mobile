class Experience {
  late String? id;
  late String? companyName;
  late String? companyCityLocation;
  late String? companyLogoUrl;
  late String? emailAddress;
  late String? jobPosition;
  late String? yearStarted;
  late String? yearEnded;
  
  
  Experience(this.id, this.companyName, this.companyCityLocation, this.companyLogoUrl, this.emailAddress, this.jobPosition, this.yearStarted, this.yearEnded);


  Experience.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    companyName = json['company_name'] ?? '';
    companyCityLocation = json['company_city_location'] ?? '';
    companyLogoUrl = json['company_logo_url'] ?? '';
    emailAddress = json['email_address'] ?? '';
    jobPosition = json['job_position'] ?? '';
    yearStarted = json['year_started'] ?? '';
    yearEnded = json['year_ended'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'company_name' : companyName,
      'company_city_location': companyCityLocation,
      'company_logo_url': companyLogoUrl,
      'email_address': emailAddress,
      'job_position': jobPosition,
      'year_started': yearStarted,
      'year_ended': yearEnded
    };
  }
}