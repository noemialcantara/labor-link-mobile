class Job {
  late String jobId;
  late String jobName;
  late String jobDescription;
  late List<dynamic> jobRequirements;
  late List<dynamic> jobResponsibilities;
  late List<dynamic> jobCategories;
  late String jobLevels;
  late String employmentType;
  late double minimumSalary;
  late double maximumSalary;
  late bool isSalaryToBeDeclared;
  late bool isSalaryConfidential;
  late String companyName;
  late String companyLogo;
  late String jobStateLocation;
  late String jobCityLocation;
  late int requiredHireCount;
  
  Job(this.jobId, this.jobName, this.jobDescription, this.jobRequirements, this.jobResponsibilities, this.jobCategories,
      this.jobLevels, this.employmentType, this.minimumSalary, this.maximumSalary, this.isSalaryToBeDeclared, 
      this.isSalaryConfidential, this.companyName, this.companyLogo, this.jobStateLocation, this.jobCityLocation, this.requiredHireCount);


  Job.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'] ?? '';
    jobName = json['job_name'] ?? '';
    jobDescription = json['job_description'] ?? '';
    jobRequirements = json['job_requirements'] ?? [];
    jobResponsibilities = json['job_responsibilities'] ?? [];
    jobCategories = json['job_categories'] ?? [];
    jobLevels = json['job_levels'] ?? '';
    employmentType = json['employment_type'] ?? '';
    minimumSalary = json['min_salary'] ?? 0.00;
    maximumSalary = json['max_salary'] ?? 0.00;
    isSalaryToBeDeclared = json['is_salary_to_be_declared'] ?? false;
    isSalaryConfidential = json['is_salary_confidential'] ?? false;
    companyName = json['company_name'] ?? '';
    companyLogo = json['company_logo_url'] ?? '';
    jobCityLocation = json['job_city_location'] ?? '';
    jobStateLocation = json['job_state_location'] ?? '';    
    requiredHireCount = json['required_applicant_count'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'job_id' : jobId,
      'job_name' : jobName,
      'job_description': jobDescription,
      'job_requirements': jobRequirements,
      'job_responsibilities': jobResponsibilities,
      'job_categories': jobCategories,
      'job_levels': jobLevels,
      'employment_type': employmentType,
      'min_salary': minimumSalary,
      'max_salary': maximumSalary,
      'is_salary_to_be_declared': isSalaryToBeDeclared,
      'is_salary_confidential': isSalaryConfidential,
      'company_name': companyName,
      'company_logo_url': companyLogo,
      'job_city_location': jobCityLocation,
      'job_state_location': jobStateLocation,
      'required_applicant_count': requiredHireCount
    };
  }
}