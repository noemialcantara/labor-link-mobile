import 'package:cloud_firestore/cloud_firestore.dart';

class Subscriber {
  late String? duration;
  late String? employerEmailAddress;
  late String? monthlyPayment;
  late String? plan;
  late String? premiumPlanStartingDate;
  late String? premiumPlanEndingDate;
  late String? isCancelled;
  late String? id;
  late Timestamp? createdOn;
  
  
  Subscriber(this.duration, this.employerEmailAddress, this.monthlyPayment, this.plan, this.premiumPlanStartingDate, this.premiumPlanEndingDate, this.isCancelled, this.id, this.createdOn);


  Subscriber.fromJson(Map<String, dynamic> json) {
    duration = json['duration'] ?? '';
    employerEmailAddress = json['employer_email_address'] ?? '';
    monthlyPayment = json['monthly_payment'] ?? '';
    plan = json['plan'] ?? '';
    premiumPlanStartingDate = json['premium_plan_starting_date'] ?? '';
    premiumPlanEndingDate = json['premium_plan_ending_date'] ?? '';
    isCancelled = json['is_cancelled'] ?? '';
    id = json['id'] ?? '';
    createdOn = json['created_on'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'duration' : duration,
      'employer_email_address' : employerEmailAddress,
      'monthly_payment': monthlyPayment,
      'plan': plan,
      'premium_plan_starting_date': premiumPlanStartingDate,
      'premium_plan_ending_date': premiumPlanEndingDate,
      'is_cancelled': isCancelled,
      'id': id,
      'created_on': createdOn
    };
  }
}