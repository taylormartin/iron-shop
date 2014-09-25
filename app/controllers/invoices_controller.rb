class InvoicesController < ApplicationController
  def index
    gon.invoices = Invoice.all
  end

  def create
    cart = build_cart
    @invoice = cart.checkout!
    @invoice.items << cart.items
    if @invoice.save
      session[:cart] = []
      redirect_to invoice_path(@invoice), notice: "Successfully checked out"
    else
      redirect_to cart_path, alert: "Unable to check out"
    end
  end

  def show
    @invoice = current_user.invoices.find params[:id]
    gon.invoiceId = @invoice.id
    gon.invoiceAmount = @invoice.amount
    gon.invoicePaid = @invoice.paid
    gon.invoiceItems = @invoice.items
  end

  def close
    @invoice = current_user.invoices.find params[:id]
    begin
      CardProcessor.new(@invoice, params[:stripeToken]).process
      flash[:success] = "Your purchase went through"
    rescue
      flash[:error] = e.message

    end
    redirect_to invoice_path(@invoice)
  end
  
end