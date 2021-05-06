class BillingInfoModel{
  String id;
  String name;
  String userPhone;
  String userID;
  String monthYear;
  String billType;
  String billingNumber;
  String transactionId;
  String amount;
  String state;
  String timeStamp;
  String payDate;

  BillingInfoModel({
    this.id,
    this.name,
    this.monthYear,
    this.billType,
    this.billingNumber,
    this.transactionId,
    this.timeStamp,
    this.state,this.amount,this.userID,this.userPhone,this.payDate});
}