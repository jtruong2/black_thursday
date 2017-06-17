require_relative 'test_helper'
require_relative '../lib/invoice_repository.rb'
require 'pry'

class InvoiceRepositoryTest < Minitest::Test

  def test_new_instance
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_instance_of InvoiceRepository, ir
  end

  def test_return_instance_with_find_by_id_good_id
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)
    actual = ir.find_by_id(30).id

    assert_equal 30, actual
  end

  def test_return_nil_with_find_by_id_bad_number
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_nil ir.find_by_id(3)
  end

  def test_return_find_all_by_customer_id_good_id
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal 2, ir.find_all_by_customer_id(1).length
    assert_instance_of Invoice, ir.find_all_by_customer_id(1)[0]
  end

  def test_return_find_all_by_customer_id_bad_id
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal [], ir.find_all_by_customer_id(10)
  end

  def test_find_all_by_merchant_id_good_id
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal 2, ir.find_all_by_merchant_id(12334208).length
    assert_instance_of Invoice, ir.find_all_by_merchant_id(12334208)[0]
  end

  def test_find_all_by_merchant_id_bad_id
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal [], ir.find_all_by_merchant_id(34)
  end

  def test_find_all_by_status_pending
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal 3, ir.find_all_by_status("pending").length
    assert_instance_of Invoice, ir.find_all_by_status("pending")[0]
  end

  def test_find_all_by_status_shipped
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal 4, ir.find_all_by_status("shipped").length
    assert_instance_of Invoice, ir.find_all_by_status("shipped")[0]
  end

  def test_find_all_by_status_returned
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal 1, ir.find_all_by_status("returned").length
    assert_instance_of Invoice, ir.find_all_by_status("returned")[0]
  end

  def test_find_all_by_status_not_typed_right
    ir = InvoiceRepository.new("./test/data/invoices_fixture.csv", self)

    assert_equal [], ir.find_all_by_status("pend")
  end

end
