class Transaction {
  late String? amountPaid;
  late String? paymentMethod;
  late String? status;
  late String? subscriberName;
  late String? transactionDateTime;
  late String? transactionId;
  late String? type;
  
  
  Transaction(this.amountPaid, this.paymentMethod, this.status, this.subscriberName, this.transactionDateTime, this.transactionId, this.type);


  Transaction.fromJson(Map<String, dynamic> json) {
    amountPaid = json['amount_paid'] ?? '';
    paymentMethod = json['payment_method'] ?? '';
    status = json['status'] ?? '';
    subscriberName = json['subscriber_name'] ?? '';
    transactionDateTime = json['transaction_datetime'] ?? '';
    transactionId = json['transaction_id'] ?? '';
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'amount_paid' : amountPaid,
      'payment_method' : paymentMethod,
      'status': status,
      'subscriber_name': subscriberName,
      'transaction_datetime': transactionDateTime,
      'transaction_id': transactionId,
      'type': type
    };
  }
}