app.service("couponFormService", function($http) {
  return({
    addCoupon: addCoupon
  });

  function addCoupon(formData) {
    var request = $http({
      method: "POST",
      url: "coupons.json",
      data: {
        code: formData.couponCode,
        discount: formData.discountPercentage
      }
    });


    return( request );
  };
});