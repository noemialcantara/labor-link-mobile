class JobApplication {
  late String applicantName;
  late String resumeLink;
  late String coverLetter;
  late String jobId;
  late String applicantEmail;
  
  
  JobApplication(this.applicantName, this.resumeLink, this.coverLetter, this.jobId, this.applicantEmail);


  JobApplication.fromJson(Map<String, dynamic> json) {
    applicantName = json['applicant_name'] ?? '';
    resumeLink = json['resume_link'] ?? '';
    coverLetter = json['cover_letter'] ?? '';
    jobId = json['job_id'] ?? 0;
    applicantEmail = json['applicant_email'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'applicant_name' : applicantName,
      'resume_link' : resumeLink,
      'cover_letter': coverLetter,
      'job_id': jobId,
      'applicant_email': applicantEmail
    };
  }
}