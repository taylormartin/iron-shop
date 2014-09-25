app.controller("invoicesCtrl", function($scope, InvoiceHelperService) {
  $scope.invoices = gon.invoices;
  $scope.paidDisplay = function(paid) {
    return InvoiceHelperService.paidDisplay(paid);
  };
});