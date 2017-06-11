require_relative "test_helper.rb"
require_relative "../lib/merchant"
require_relative "../lib/merchant_repository"
require_relative "../lib/sales_engine"

class MerchantTest < Minitest::Test

  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({
      :items => "./test/data/itemsample.csv",
      :merchants => "./test/data/merchant_fixture.csv",
      :salesanalyst => "./test/data/salesanalystsample.csv",
      :invoices => "./test/data/invoices_fixture.csv",
      :invoice_items => "./test/data/invoice_items_fixture.csv",
      :transactions => "./test/data/transactions_fixture.csv",
      :customers => "./test/data/customers_fixture.csv" })
  end

  def test_new_instance
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",self)

    assert_instance_of Merchant, mr.contents[12334105]
  end

  def test_can_access_name
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",self)

    assert_equal "MiniatureBikez", mr.contents[12334113].name
  end

  def test_can_access_created_at
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",self)

    assert_equal "2010-07-15 00:00:00 -0600", mr.contents[12334123].created_at.to_s
  end

  def test_can_acces_updated_at
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",self)

    assert_equal "2012-04-16 00:00:00 -0600", mr.contents[12334135].updated_at.to_s
  end

  def test_can_access_id
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",self)

    assert_equal 12334132, mr.contents[12334132].id
  end

  def test_find_all_items_by_merchant_id
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",se)
    expected = 12334185
    x = mr.parent.items.find_all_by_merchant_id(12334185)
    actual = x[0]

    assert_instance_of Item, actual
    assert_equal [], mr.parent.items.find_all_by_merchant_id(12335185)
  end

  def test_find_all_invoices_by_merchant_id
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",se)
    x = mr.parent.invoices.find_all_by_merchant_id(12334771)
    actual = x[0]
binding.pry
    assert_instance_of Invoice, actual
    assert_equal [], mr.parent.invoices.find_all_by_merchant_id(134457)
  end

  def test_find_all_customers_by_merchant_id
    skip
    mr = MerchantRepository.new("./test/data/merchant_fixture.csv",se)
    m = mr.contents.first
  end



end
