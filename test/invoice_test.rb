require_relative 'test_helper'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'
require_relative'../lib/sales_engine'
require 'pry'

class InvoiceTest < Minitest::Test

  attr_reader :i
  attr_reader :se

  def setup
    @i = Invoice.new({id:         "18",
                      customer_id: "5",
                      merchant_id: "12334839",
                      status:      "shipped",
                      created_at:  "2001-12-13",
                      updated_at:  "2006-05-02"}, self)

    @se = SalesEngine.from_csv({:items=>"./data/items.csv",
                                :merchants => "./data/merchants.csv",
                                :invoices =>"./data/invoices.csv",
                                :invoice_items=>"./data/invoice_items.csv",
                                :transactions=>"./data/transactions.csv",
                                :customers=>"./data/customers.csv"})
  end

  def test_new_instance

    assert_instance_of Invoice, i
  end

  def test_return_id_integer

    assert_equal 18, i.id
  end

  def test_return_customer_id

    assert_equal 5, i.customer_id
  end

  def test_return_merchant_id

    assert_equal 12334839, i.merchant_id
  end

  def test_return_status

    assert_equal :shipped, i.status
    assert_instance_of Symbol, i.status
  end

  def test_return_created_at

    assert_equal "2001-12-13 00:00:00 -0700", i.created_at.to_s
    assert_instance_of Time, i.created_at
  end

  def test_return_updated_at

    assert_equal "2006-05-02 00:00:00 -0600", i.updated_at.to_s
    assert_instance_of Time, i.updated_at
  end

  def test_find_total
    ir =se.invoices
    inv = ir.contents
    tr =inv[1]


    assert_equal 21067.77, tr.total.to_f
  end

end
