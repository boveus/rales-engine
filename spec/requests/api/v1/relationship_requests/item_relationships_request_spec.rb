require 'rails_helper'
describe "Items Relationships API" do

  before(:each) do
    @merchant = Merchant.create(id: 1, name: "Timmy")
    @merchant_2 = Merchant.create(id: 2, name: "Johnny")
    customer = Customer.create(id: 1, first_name: "Pauly", last_name: "Shore")
    customer2 = Customer.create(id: 2, first_name: "Jazzy", last_name: "Jeff")
    item = Item.create(id: 1, merchant_id: 1, name: 'Sofa')

    merchant_2_invoice = @merchant_2.invoices.create(
      customer: customer,
      merchant: @merchant_2,
      status: "shipped",
      created_at: '2012-02-27 14:53:59 UTC'
    )
    good_invoice = @merchant.invoices.create(
      customer: customer,
      merchant: @merchant,
      status: "shipped",
      created_at: '2012-02-27 14:53:59 UTC'
      )
    bad_invoice = @merchant.invoices.create(
      customer: customer,
      merchant: @merchant,
      status: "shipped",
      created_at: '2012-02-27 14:53:59 UTC'
    )
    one_month_later_good_invoice = @merchant.invoices.create(
      customer: customer,
      merchant: @merchant,
      status: "shipped",
      created_at: '2012-03-27 14:53:59 UTC'
      )
    another_invoice = @merchant.invoices.create(
      customer: customer2,
      merchant: @merchant,
      status: "shipped",
      created_at: '2012-02-27 14:53:59 UTC'
    )

    3.times do
      good_invoice.invoice_items.create(
        item_id: item.id,
        quantity: 2,
        unit_price: 50,
        created_at: '2012-02-27 14:53:59 UTC'
      )
      bad_invoice.invoice_items.create(
        item_id: item.id,
        quantity: 2,
        unit_price: 100,
        created_at: '2012-02-27 14:53:59 UTC'
      )
      one_month_later_good_invoice.invoice_items.create(
        item_id: item.id,
        quantity: 4,
        unit_price: 75,
        created_at: '2012-03-27 14:53:59 UTC'
      )
      another_invoice.invoice_items.create(
        item_id: item.id,
        quantity: 4,
        unit_price: 75,
        created_at: '2012-03-27 14:53:59 UTC'
      )
      merchant_2_invoice.invoice_items.create(
        item_id: item.id,
        quantity: 4,
        unit_price: 75,
        created_at: '2012-03-27 14:53:59 UTC'
      )
    end
  good_invoice.transactions.create(
    credit_card_number: '666',
    result: "success",
    created_at: '2012-03-27 14:53:59 UTC'
  )
  one_month_later_good_invoice.transactions.create(
    credit_card_number: '666',
    result: "success",
    created_at: '2012-04-27 14:53:59 UTC'
  )
  bad_invoice.transactions.create(
    credit_card_number: '666',
    result: "failed",
    created_at: '2012-03-27 14:53:59 UTC'
  )
  merchant_2_invoice.transactions.create(
    credit_card_number: '666',
    result: "success",
    created_at: '2012-03-27 14:53:59 UTC'
  )
end

  context "/api/v1/items/:id/invoice_items" do
    it "returns a collection of associated invoice item" do
      get "/api/v1/items/#{Item.first.id}/invoice_items"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_success
      expect(invoice_item.last["id"]).to eq(InvoiceItem.last.id)
    end
  end
  context "/api/v1/items/:id/merchant" do
    it "returns a collection of associated invoice item" do
      get "/api/v1/items/#{Item.first.id}/merchant"

      merchant = JSON.parse(response.body)

      expect(response).to be_success
      expect(merchant["id"]).to eq(Item.first.merchant_id)
    end
  end
end
