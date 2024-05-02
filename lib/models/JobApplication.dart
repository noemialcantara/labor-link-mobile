class JobApplication {
  late String applicantName;
  late String resumeLink;
  late String coverLetter;
  late String jobId;
  late String applicantEmail;
  late String companyLogoUrl;
  late String jobName;
  late String companyName;
  late String minSalary;
  late String jobCityLocation;
  late String status;
  late String employmentType;
  
  
  JobApplication(this.applicantName, this.resumeLink, this.coverLetter, this.jobId, this.applicantEmail, this.companyLogoUrl, this.jobName, this.companyName,
  this.minSalary, this.jobCityLocation, this.status, this.employmentType);


  JobApplication.fromJson(Map<String, dynamic> json) {
    applicantName = json['applicant_name'] ?? '';
    resumeLink = json['resume_link'] ?? '';
    coverLetter = json['cover_letter'] ?? '';
    jobId = json['job_id'] ?? 0;
    applicantEmail = json['applicant_email'] ?? '';
    companyLogoUrl = json['company_logo_url'] ?? '';
    jobName = json['job_name'] ?? '';
    companyName = json['company_name'] ?? '';
    minSalary = json['min_salary'] ?? '';
    jobCityLocation = json['job_city_location'] ?? '';
    status = json['status'] ?? '';
    employmentType = json['employment_type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'applicant_name' : applicantName,
      'resume_link' : resumeLink,
      'cover_letter': coverLetter,
      'job_id': jobId,
      'applicant_email': applicantEmail,
      'company_logo_url': companyLogoUrl,
      'job_name': jobName,
      'company_name': companyName,
      'min_salary': minSalary,
      'job_city_location': jobCityLocation,
      'status': status,
      'employment_type': employmentType
    };
  }
}