require_relative 'test_helper.rb'
require_relative '../lib/invoice_item'
require_relative '../lib/invoice_item_repository'
require 'pry'

class InvoiceItemTest < Minitest::Test

  attr_reader :invoice_item

  def setup
    @invoice_item = InvoiceItem.new({:id         => "190",
                                     :item_id    => "263454779",
                                     :invoice_id => "42",
                                     :quantity   => "2",
                                     :unit_price => "15191",
                                     :created_at => "2012-03-27 14:54:11 UTC",
                                     :updated_at => "2012-03-27 14:54:11 UTC"}, self)
  end

  def test_new_instance

    assert_instance_of InvoiceItem, invoice_item
  end

  def test_return_id

    assert_equal 190, invoice_item.id
    assert_instance_of Fixnum, invoice_item.id
  end

  def test_return_invoice_id

    assert_equal 42, invoice_item.invoice_id
    assert_instance_of Fixnum, invoice_item.invoice_id
  end

  def test_return_item_id

    assert_equal 263454779, invoice_item.item_id
    assert_instance_of Fixnum, invoice_item.item_id
  end

  def test_return_quantity

    assert_equal 2, invoice_item.quantity
    assert_instance_of Fixnum, invoice_item.quantity
  end

  def test_return_unit_price

    assert_equal 151.91, invoice_item.unit_price
    assert_instance_of BigDecimal, invoice_item.unit_price
  end

  def test_return_created_at

    assert_equal "2012-03-27 14:54:11 UTC", invoice_item.created_at.to_s
    assert_instance_of Time, invoice_item.created_at
  end

  def test_return_updated_at

    assert_equal "2012-03-27 14:54:11 UTC", invoice_item.updated_at.to_s
    assert_instance_of Time, invoice_item.updated_at
  end

  def test_unit_price_to_dollars
    iir = InvoiceItemRepository.new("./test/data/invoice_items_fixture.csv",
                                    self)
    invoice_item = InvoiceItem.new({:id         => "190",
                                     :item_id    => "263454779",
                                     :invoice_id => "42",
                                     :quantity   => "2",
                                     :unit_price => "15191",
                                     :created_at => "2012-03-27 14:54:11 UTC",
                                     :updated_at => "2012-03-27 14:54:11 UTC"},
                                     iir)

    assert_equal 151.91, invoice_item.unit_price_to_dollars(190)
  end
end
