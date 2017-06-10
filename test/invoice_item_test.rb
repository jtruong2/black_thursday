require_relative 'test_helper.rb'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'
require 'pry'

class InvoiceItemTest < Minitest::Test

  attr_reader :iir,
              :ii


  def setup
    @iir = InvoiceItemRepository.new("./test/data/invoice_items_fixture.csv", self)

    @ii = InvoiceItem.new({ id:          "10",
                           item_id:     "263523644",
                           invoice_id:  "2",
                           quantity:    "4",
                           unit_price:  "1859",
                           created_at:  "2012-03-27 14:54:09 UTC",
                           updated_at:  "2012-03-27 14:54:09 UTC" }, @iir)
  end

  def test_new_instance

    assert_instance_of InvoiceItem, ii
  end

  def test_return_id_integer

    assert_equal 10, ii.id
  end

  def test_return_invoice_id

    assert_equal 2, ii.invoice_id
  end

  def test_return_item_id

    assert_equal 263523644, ii.item_id
  end

  def test_return_quantity

    assert_equal 4, ii.quantity
  end

  def test_return_unit_price

    assert_equal 18.59, ii.unit_price
    assert_instance_of BigDecimal, ii.unit_price
  end

  def test_return_created_at

    assert_equal "2012-03-27 14:54:09 UTC", ii.created_at.to_s
    assert_instance_of Time, ii.created_at
  end

  def test_return_updated_at

    assert_equal "2012-03-27 14:54:09 UTC", ii.updated_at.to_s
    assert_instance_of Time, ii.updated_at
  end

  def test_unit_price_to_dollars

    assert_equal 707.83, ii.unit_price_to_dollars(41)
  end
end
