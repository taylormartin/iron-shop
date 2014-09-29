app.controller("cartCtrl", function($scope, $http) {
  $scope.items = gon.items;
  $scope.subtotal = gon.subtotal;
  $scope.discount = gon.discount;
  $scope.codes_applied = gon.codes_applied;
  $scope.tax_rate = gon.tax_rate;
  $scope.total = gon.total;

  $scope.set_data = function(data) {
    $scope.items = data["items"];
    $scope.subtotal = data["subtotal"];
    $scope.discount = data["discount"];
    $scope.codes_applied = data["codes_applied"];
    $scope.tax_rate = data["tax_rate"];
    $scope.total = data["total"];
  };


//  Deleting item ajax call
  $scope.delete_item = function(item_id) {
    $http({
      url: 'cart/remove-cart/' + item_id + ".json",
      method: "DELETE"
    }).success(function(data) {
      $scope.set_data(data);
    }).error(function(data, status, headers, config){
       console.log("error with status", status, "headers", headers, "config", config)
    });
  };

//  Adding a promo code
  $scope.codeInput = "";
  $scope.add_code = function () {
    $http({
      url: 'cart/code/' + $scope.codeInput + '.json',
      method: "POST"
    }).success(function(data) {
      $scope.set_data(data);
      $scope.codeInput = "";
    }).error(function(data, status, headers, config) {
      console.log("error with status", status, "headers", headers, "config", config)
    });
  };

  $scope.remove_code = function(code) {
    $http({
      url: 'cart/code/' + code + '.json',
      method: "DELETE"
    }).success(function(data) {
      $scope.set_data(data);
      $scope.codeInput = "";
    }).error(function(data, status, headers, config) {
      console.log("error with status", status, "headers", headers, "config", config)
    });
  };
});