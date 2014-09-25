class CartsController < ApplicationController
  respond_to :json, except: [:show_cart, :add_cart]
  before_action :authenticate_user!
  before_action :set_session, only: [:add_cart, :remove_cart]
  skip_before_filter :set_gon_data
  skip_before_filter :build_cart
  # before_action :dummy_data


  def show_cart
    build_cart
    set_gon_data
  end

  def data
    build_cart
  end

  def add_cart
    item_id = params[:id].to_i
    if Item.find_by_id(item_id)
      session[:cart] << item_id
    end
    build_cart
    set_gon_data
    redirect_to cart_path
  end

  def remove_cart
    item_id = params[:id].to_i
    if Item.find_by_id(item_id)
      session[:cart].delete(item_id)
    end
    build_cart
    render 'data'
  end

  private

  def set_session
    session[:cart] ||= []
  end
end