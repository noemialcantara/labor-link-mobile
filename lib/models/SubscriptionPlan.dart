class SubscriptionPlan {
  late String duration;
  late String planName;
  late String price;
  
  SubscriptionPlan(this.duration, this.planName, this.price);


  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    duration = json['duration'] ?? '';
    planName = json['plan_name'] ?? '';
    price = json['price'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'duration' : duration,
      'plan_name' : planName,
      'price': price
    };
  }
}