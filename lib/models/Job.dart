class Job {
  final String company;
  final String logoUrl;
  bool isMark;
  final String title;
  final String location;
  final String time;
  final List<String> req;
  Job(this.company, this.logoUrl, this.isMark, this.title, this.location,
      this.time, this.req);

  get salary => null;
  static List<Job> generateJobs() {
    return [
      Job(
        'Google LLC',
        'assets/images/google_logo.png',
        false,
        'Sr. Software Engineer',
        '123 Marion , New York\nUnited States',
        'Full Time',
        [
          'Bachelors degree in industrial design, manufacturing, engineering, or a related field.',
          'A creative eye, good imagination, and vision.',
          'A firm grasp of market trends and consumer preferences.',
          'Practical experience using computer-aided design software.',
          'Good technical and IT skills.'
        ],
      ),
      Job(
        'Airbnb Inc',
        'assets/images/airbnb_logo.png',
        false,
        'UI/UX Designer',
        '456 Marion , New York\nUnited States',
        'Full Time',
        [
          'Bachelors degree in industrial design, manufacturing, engineering, or a related field',
          'A creative eye, good imagination, and vision',
          'A firm grasp of market trends and consumer preferences',
          'Practical experience using computer-aided design software',
          'Good technical and IT skills'
        ],
      ),
      Job(
        'Linkedin',
        'assets/images/linkedin_logo.png',
        false,
        'Software Engineering Manager',
        '789 Marion , New York\nUnited States',
        'Full Time',
        [
          'Bachelors degree in industrial design, manufacturing, engineering, or a related field',
          'A creative eye, good imagination, and vision',
          'A firm grasp of market trends and consumer preferences',
          'Practical experience using computer-aided design software',
          'Good technical and IT skills'
        ],
      ),
    ];
  }
}