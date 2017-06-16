require_relative 'test_helper'
require_relative '../lib/invoice'
require_relative '../lib/invoice_repository'
require_relative'../lib/sales_engine'
require 'pry'

class InvoiceTest < Minitest::Test

  attr_reader :invoice

  def setup
    @invoice = Invoice.new({ :id          => "19",
                             :customer_id => "5",
                             :merchant_id => "12334372",
                             :status      => "shipped",
                             :created_at  => "2004-09-28",
                             :updated_at  => "2012-08-28"}, self)
  end

  def test_new_instance

    assert_instance_of Invoice, invoice
  end

  def test_return_id

    assert_equal 19, invoice.id
    assert_instance_of Fixnum, invoice.id
  end

  def test_return_customer_id

    assert_equal 5, invoice.customer_id
    assert_instance_of Fixnum, invoice.customer_id
  end

  def test_return_merchant_id

    assert_equal 12334372, invoice.merchant_id
    assert_instance_of Fixnum, invoice.merchant_id
  end

  def test_return_status

    assert_equal :shipped, invoice.status
  end

  def test_return_created_at

    assert_equal "2004-09-28 00:00:00 -0600", invoice.created_at.to_s
    assert_instance_of Time, invoice.created_at
  end

  def test_return_updated_at

    assert_equal "2012-08-28 00:00:00 -0600", invoice.updated_at.to_s
    assert_instance_of Time, invoice.updated_at
  end

  def test_find_total
    se = SalesEngine.from_csv({:items=>"./data/items.csv",:merchants => "./data/merchants.csv",:invoices =>"./data/invoices.csv",:invoice_items=>"./data/invoice_items.csv",:transactions=>"./data/transactions.csv",:customers=>"./data/customers.csv"})
    ir =se.invoices
    inv = ir.contents
    tr =inv[1]

    assert_equal 21067.77, tr.total.to_f
  end

end
