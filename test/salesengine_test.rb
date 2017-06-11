require_relative '../test/test_helper.rb'
require_relative"../lib/sales_engine"

class SalesEngineTest < Minitest::Test
  def setup

      {:items => "./test/data/itemsample.csv",
      :merchants => "./test/data/merchant_fixture.csv",
      :salesanalyst => "./test/data/salesanalystsample.csv",
      :invoices => "./test/data/invoices_fixture.csv",
      :invoice_items => "./test/data/invoice_items_fixture.csv",
      :transactions => "./test/data/transactions_fixture.csv",

      :customers => "./test/data/customers_fixture.csv" })
  end

  def test_can_access_items_instance_variable
    skip
    se = SalesEngine.from_csv({:merchants => "./test/merchants_test.csv"})
    assert_nil se.items
  end

  def test_it_exists
    se = SalesEngine.from_csv(setup)

    assert_instance_of SalesEngine, se
  end

end
