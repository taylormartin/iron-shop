class CouponsController < ApplicationController
  respond_to :json, :only => [:create, :update]

  def index
    authorize! :index, Coupon
    gon.coupons = current_user.coupons
  end

  def create
    @coupon = current_user.coupons.new create_params.merge(status:true)
    authorize! :create, @coupon
    if @coupon.save
      render :json => current_user.coupons
    else
      head :bad_request
    end

  end

  def update
    @coupon = Coupon.find params[:id]
    authorize! :update, @coupon, :message => "Unable to update this coupon"

    if @coupon.update update_params
      render :json => current_user.coupons
      # redirect_to coupons_path, flash[:success] => "Your coupon was updated!"
    else
      head :bad_request
      # redirect_to coupons_path, flash[:error] => "Your coupon was not updated"
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