class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :build_cart
  before_filter :set_gon_data

  before_action :configure_permitted_parameters, if: :devise_controller?
  after_filter :set_csrf_cookie_for_ng


  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to root_path, :alert => exception.message
    else
      redirect_to new_user_session_path, :alert => "Please sign in"
    end
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def build_cart
    @cart = Cart.new current_user, item_ids: (session[:cart] || [])
  end

  def set_gon_data
    gon.items = @cart.items
    gon.subtotal = @cart.subtotal
    gon.tax_rate = @cart.tax_rate
    gon.total = @cart.total
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:role, :email, :password, :password_confirmation)
    end
  end

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

private

  def render_invalid obj
    render json: { errors: obj.errors.full_messages }, status: 422
  end

end
