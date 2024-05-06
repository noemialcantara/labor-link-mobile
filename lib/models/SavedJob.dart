class SavedJob {
  late String id;
  late String emailAddress;
  late String jobId;

  SavedJob({required this.id, required this.emailAddress, required this.jobId});

  SavedJob.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    emailAddress = json['email_address'] ?? '';
    jobId = json['job_id'] ?? '';
  }
}