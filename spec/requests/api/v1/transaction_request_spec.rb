require 'rails_helper'

describe "Transactions API" do
  before(:each) do
    merchant = Merchant.create(name: "Timmy")
    customer = Customer.create(id: 1, first_name: "Pauly", last_name: "Shore")
    item = Item.create(id: 1, name: "Hula Hoop", merchant_id: merchant.id)
    invoice = merchant.invoices.create(
      customer: customer,
      merchant: merchant,
      status: "shipped",
      created_at: '2012-02-27 14:53:59 UTC'
    )
    id = 0
    3.times do
      invoice.transactions.create(
        id: id += 1,
        credit_card_number: '666',
        result: "success",
        created_at: '2012-03-27 14:53:59 UTC'
      )
    end

    invoice.transactions.create(
      id: 4,
      credit_card_number: '333',
      result: "failed",
      created_at: '2012-03-27 14:53:59 UTC'
    )
  end

  context "GET /transactions" do
    it "sends a list of transactions" do
      get '/api/v1/transactions'

      transactions = JSON.parse(response.body)

      expect(response).to be_success
      expect(transactions.first['credit_card_number']).to eq("666")
      expect(transactions.last['credit_card_number']).to eq("333")
      expect(transactions.count).to eq(4)
    end
  end

  context "GET /api/v1/transactions/:id" do
    it "sends data on a transaction" do
      get '/api/v1/transactions/1'

      transaction = JSON.parse(response.body)

      expect(response).to be_success
      expect(transaction['credit_card_number']).to eq("666")
    end
  end

  context "GET /transactions/find?credit_card_number=666" do
    it "sends data on a transaction meeting the search criteria" do
      get "/api/v1/transactions/find?credit_card_number=666"

      transaction = JSON.parse(response.body)

      expect(response).to be_success
      expect(transaction['credit_card_number']).to eq("666")
    end
  end

  context "GET /transactions/find_all?credit_card_number=666" do
    it "sends data on a transactions meeting the search criteria" do
      get "/api/v1/transactions/find_all?credit_card_number=666"

      transactions = JSON.parse(response.body)

      expect(response).to be_success
      expect(transactions.first['credit_card_number']).to eq("666")
      expect(transactions.last['credit_card_number']).to eq("666")
      expect(transactions.count).to eq(3)
    end
  end

  context "GET /transactions/find?invoice_id=1" do
    it "sends data on a transaction meeting the search criteria" do
      get "/api/v1/transactions/find?invoice_id=1"

      transaction = JSON.parse(response.body)

      expect(response).to be_success
      expect(transaction['credit_card_number']).to eq("666")
    end
  end

  context "GET /transactions/find_all?invoice_id=1" do
    it "sends data on a transactions meeting the search criteria" do
      get "/api/v1/transactions/find_all?invoice_id=1"

      transactions = JSON.parse(response.body)

      expect(response).to be_success
      expect(transactions.first['credit_card_number']).to eq("666")
      expect(transactions.last['credit_card_number']).to eq("333")
      expect(transactions.count).to eq(4)
    end
  end
end
