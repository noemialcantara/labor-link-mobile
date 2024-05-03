class Applicant {
  late String? fullName;
  late String? address;
  late String? emailAddress;
  late String? jobRole;
  late String? profileUrl;
  late String? minimumExpectedSalary;
  late String? maximumExpectedSalary;
  late String? yearsOfExperience;
  
  
  Applicant(this.fullName, this.address, this.emailAddress, this.jobRole, this.profileUrl, this.minimumExpectedSalary, this.maximumExpectedSalary, this.yearsOfExperience);


  Applicant.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'] ?? '';
    address = json['address'] ?? '';
    emailAddress = json['email_address'] ?? '';
    jobRole = json['job_role'] ?? '';
    profileUrl = json['profile_url'] ?? '';
    minimumExpectedSalary = json['minimum_expected_salary'] ?? '';
    maximumExpectedSalary = json['maximum_expected_salary'] ?? '';
    yearsOfExperience = json['years_of_experience'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name' : fullName,
      'address' : address,
      'email_address': emailAddress,
      'job_role': jobRole,
      'profile_url': profileUrl,
      'minimum_expected_salary': minimumExpectedSalary,
      'maximum_expected_salary': maximumExpectedSalary,
      'years_of_experience': yearsOfExperience
    };
  }
}