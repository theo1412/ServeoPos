enum PayMethod { cb, cash, tr, other }

class PaymentLine {
  double amount;
  PayMethod method;

  PaymentLine(this.amount, this.method);
}