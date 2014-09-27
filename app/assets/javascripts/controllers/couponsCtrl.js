app.controller("CouponsCtrl", function($scope) {
  $scope.coupons = gon.coupons;
  $scope.openCouponModal = function() {
    $('#new-coupon-modal').modal();
  };
});