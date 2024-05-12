class Feedback {
  late String applicantEmailAddress;
  late String employerEmailAddress;
  late String comments;
  late String rating;
  late String jobId;
  
  Feedback(this.applicantEmailAddress, this.employerEmailAddress, this.comments, this.rating, this.jobId);


  Feedback.fromJson(Map<String, dynamic> json) {
    applicantEmailAddress = json['applicant_email_address'] ?? '';
    employerEmailAddress = json['employer_email_address'] ?? '';
    comments = json['comments'] ?? '';
    rating = json['rating'] ?? '';
    jobId = json['job_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'applicant_email_address' : applicantEmailAddress,
      'employer_email_address' : employerEmailAddress,
      'comments': comments,
      'rating': rating,
      'job_id': jobId
    };
  }
}