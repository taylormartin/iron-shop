app.controller("CouponsCtrl", function($scope, $http, couponFormService) {
  $scope.coupons = gon.coupons;
  $scope.openCouponModal = function() {
    $('#new-coupon-modal').modal();
  };
// Form Submission
  $scope.form = {};
  $scope.formSubmit = function() {
    result = couponFormService.addCoupon($scope.form);

    result.success( function(data) {
      $scope.coupons = data;
      $('#new-coupon-modal').modal('toggle');
    });
  };

  $scope.toggleStatus = function(couponId, couponStatus) {
    $http({
      url: 'coupons/' + couponId,
      data: { status: !couponStatus },
      method: "PATCH"
      })
      .success( function(data, status, headers, config) {
        debugger;
        $scope.coupons = data;
      })
      .error( function(data, status, headers, config) {
        debugger;
        alert("Couldn't do it. Good luck!");
      });
  };
});