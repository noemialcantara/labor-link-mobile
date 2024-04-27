class JobCategory {
  late String category;
  late String categoryLogo;

  JobCategory({required this.category, required this.categoryLogo});

  JobCategory.fromJson(Map<String, dynamic> json) {
    category = json['name'] ?? '';
    categoryLogo = json['icon_url'] ?? '';
  }
}