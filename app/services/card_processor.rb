class CardProcessor

  def initialize invoice, token
    @invoice = invoice
    @token = token
  end

  def process
    charge_card
    mark_invoice
  end

  def self.valid_token
    token_for_card '4242424242424242'
  end

  def self.declined_token
    token_for_card '4000000000000119'
  end

  def self.token_for_card card_number
    token = Stripe::Token.create(card: {
        number: card_number,
        exp_month: 9,
        exp_year: 2015,
        cvs: '221'
    })
    token.id
  end


  private

  def charge_card
    @charge = Stripe::Charge.create(
        :amount => (@invoice.amount * 100).to_i,
        :currency => "usd",
        :card => @token,
        :description => "Charge for invoice #{@invoice.id}"
    )
  end

  def mark_invoice
    @invoice.paid = true
    @invoice.save!
  end
end