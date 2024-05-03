class Employer {
  late String? employerName;
  late String? employerAddress;
  late String? emailAddress;
  late String? employerAbout;
  late String? logoUrl;
  late String? industry;
  late String? owner;
  late String? yearFounded;
  late String? companySize;
  late String? phone;
  
  
  Employer(this.employerName, this.employerAddress, this.emailAddress, this.employerAbout, this.logoUrl, this.industry, this.owner, this.yearFounded, this.companySize, this.phone);


  Employer.fromJson(Map<String, dynamic> json) {
    employerName = json['employer_name'] ?? '';
    employerAddress = json['employer_address'] ?? '';
    emailAddress = json['email_address'] ?? '';
    employerAbout = json['employer_about'] ?? '';
    logoUrl = json['logo_url'] ?? '';
    industry = json['industry'] ?? '';
    owner = json['owner'] ?? '';
    yearFounded = json['year_founded'] ?? '';
    companySize = json['company_size'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'employer_name' : employerName,
      'employer_address' : employerAddress,
      'email_address': emailAddress,
      'employer_about': employerAbout,
      'logo_url': logoUrl,
      'industry': industry,
      'owner': owner,
      'year_founded': yearFounded,
      'company_size': companySize,
      'phone': phone
    };
  }
}