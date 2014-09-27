class CouponsController < ApplicationController
  def index
    authorize! :index, Coupon
    gon.coupons = current_user.coupons
  end

  def create
    @coupon = current_user.coupons.new create_params.merge(status:true)
    authorize! :create, @coupon
    if @coupon.save
      redirect_to coupons_path, flash[:success] => "Your coupon was created!"
    else
      redirect_to coupons_path, flash[:error] => "Your coupon was not created!"
    end
  end

  def update
    @coupon = Coupon.find params[:id]
    authorize! :update, @coupon, :message => "Unable to update this coupon"

    if @coupon.update update_params
      redirect_to coupons_path, flash[:success] => "Your coupon was updated!"
    else
      redirect_to coupons_path, flash[:error] => "Your coupon was not updated"
    end
  end

  def destroy
    @coupon = Coupon.find params[:id]
    authorize! :destroy, @coupon, :message => "Not authorized to delete this coupon"
    Coupon.destroy @coupon
    redirect_to coupons_path, flash[:success] => "Your coupon was deleted"
  end

  private

  def create_params
    params.permit(:code, :discount)
  end

  def update_params
    params.permit(:code, :discount, :status)
  end
end