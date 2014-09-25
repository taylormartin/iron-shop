app.factory("InvoiceHelperService", function() {
  return {
    paidDisplay: function(paid) {
      if (paid) {
        return "Paid"
      } else {
        return "Unpaid"
      }
    }
  }
});