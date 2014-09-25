app.controller("invoiceCtrl", function($scope, InvoiceHelperService) {
  $scope.invoiceId = gon.invoiceId;
  $scope.invoiceAmount = gon.invoiceAmount;
  $scope.invoicePaid = gon.invoicePaid;
  $scope.invoiceItems = gon.invoiceItems;
  $scope.paidDisplay = function(paid){
    return InvoiceHelperService.paidDisplay(paid);
  };
});