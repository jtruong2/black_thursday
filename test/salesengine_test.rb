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
      :customers => "./test/data/customers_fixture.csv" }
  end

  def test_it_exists
    se = SalesEngine.from_csv(setup)

    assert_instance_of SalesEngine, se
  end

  def test_can_access_items_instance_variable
    se = SalesEngine.from_csv(setup)

    assert_instance_of ItemRepository, se.items
  end

  def test_can_access_merchants_instance_variable
    se = SalesEngine.from_csv(setup)

    assert_instance_of MerchantRepository, se.merchants
  end

  def test_can_access_sales_analyst_instance_variable
    se = SalesEngine.from_csv(setup)

    assert_instance_of SalesAnalyst, se.salesanalyst
  end

  def test_can_access_invoices_instance_variable
    se = SalesEngine.from_csv(setup)

    assert_instance_of InvoiceRepository, se.invoices
  end

  def test_can_access_invoice_items_instance_variable
    se = SalesEngine.from_csv(setup)

    assert_instance_of InvoiceItemRepository, se.invoice_items
  end

  def test_can_access_transactions_instance_variable
    se = SalesEngine.from_csv(setup)

    assert_instance_of TransactionRepository, se.transactions
  end

  def test_can_access_merchants_instance_variable
    se = SalesEngine.from_csv(setup)

    assert_instance_of MerchantRepository, se.merchants
  end
end
