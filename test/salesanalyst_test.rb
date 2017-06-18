require_relative 'test_helper.rb'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require 'pry'
class SalesAnalystTest < Minitest::Test
  def setup
    {:items=>"./test/data/sa_items_fixture.csv",
     :merchants => "./test/data/sa_merchants_fixture.csv",
     :invoices =>"./test/data/sa_invoices_fixture.csv",
     :invoice_items=>"./test/data/sa_invoice_items_fixture.csv",
     :transactions=>"./test/data/sa_transactions_fixture.csv",
     :customers=>"./test/data/sa_customers_fixture.csv"}
  end

  def setup_full
    {:items=>"./data/items.csv",
     :merchants => "./data/merchants.csv",
     :invoices =>"./data/invoices.csv",
     :invoice_items=>"./data/invoice_items.csv",
     :transactions=>"./data/transactions.csv",
     :customers=>"./data/customers.csv"}
  end

  def test_it_exists
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_instance_of SalesAnalyst, sa
  end

  def test_retrieve_average_items_per_merchant
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 1.67 ,sa.average_items_per_merchant
  end

  def test_retrieve_average_items_per_merchant_standard_deviation
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 1.15 ,sa.average_items_per_merchant_standard_deviation
  end

  def test_retrieve_merchants_with_high_item_count
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)
    a = sa.merchants_with_high_item_count

    assert_equal "Shopin1901" ,a[0].name
  end

  def test_retrieve_average_item_price_for_merchant
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 150 ,sa.average_item_price_for_merchant(12334113).to_f
  end

  def test_average_average_price_per_merchant
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 60.55, sa.average_average_price_per_merchant.to_f
  end

  def test_retrieve_golden_items
    se = SalesEngine.from_csv(setup_full)
    sa = SalesAnalyst.new(se)
    a = sa.golden_items

    assert_equal 263410685, a[0].id
    assert_equal "Test listing", a[0].name
  end

  def test_average_invoices_per_merchant
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 9.67, sa.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 2.52, sa.average_invoices_per_merchant_standard_deviation
  end

  def test_top_merchants_by_invoice_count
    se = SalesEngine.from_csv(setup_full)
    sa = SalesAnalyst.new(se)
    a = sa.top_merchants_by_invoice_count

    assert_equal 12335417, a.first.id
    assert_equal "Chemisonodimenticato", a.first.name
  end

  def test_bottom_merchants_by_invoice_count
    se = SalesEngine.from_csv(setup_full)
    sa = SalesAnalyst.new(se)
    a = sa.bottom_merchants_by_invoice_count

    assert_equal [12334235,12334601,12335560,12335000], a.map { |merch| merch.id}
    assert_equal "WellnessNeelsen", a[0].name
  end

  def test_top_days_by_invoice_count
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal ['Monday'], sa.top_days_by_invoice_count
  end

  def test_invoice_status
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 20.69, sa.invoice_status(:pending)
    assert_equal 58.62, sa.invoice_status(:shipped)
    assert_equal 20.69, sa.invoice_status(:returned)
  end

  def test_total_revenue_by_date
    se = SalesEngine.from_csv(setup_full)
    sa = SalesAnalyst.new(se)
    time = Time.parse("2009-02-07")

    assert_equal 21067.77,sa.total_revenue_by_date(time)
  end

  def test_top_revenue_earners
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 3, sa.top_revenue_earners(5).length
    assert_equal 3, sa.top_revenue_earners.length
    assert_equal 12334105, sa.top_revenue_earners(5).first.id
    assert_instance_of Merchant, sa.top_revenue_earners(5)[0]
  end

  def test_merchants_ranked_by_revenue
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 12334105, sa.merchants_ranked_by_revenue.first.id
    assert_equal 12334112, sa.merchants_ranked_by_revenue.last.id
    assert_instance_of Merchant, sa.merchants_ranked_by_revenue.first
  end

  def test_merchants_with_pending_invoices
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 3, sa.merchants_with_pending_invoices.length
  end

  def test_revenue_by_merchant
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 73777.17, sa.revenue_by_merchant(12334105).to_f
    assert_instance_of BigDecimal, sa.revenue_by_merchant(12334113)
  end

  def test_merchants_with_only_one_item
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 2, sa.merchants_with_only_one_item.length
    assert_instance_of Merchant, sa.merchants_with_only_one_item[0]
  end

  def test_merchants_with_only_one_item_registered_in_month
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 12334113, sa.merchants_with_only_one_item_registered_in_month("March")[0].id
    assert_instance_of Merchant, sa.merchants_with_only_one_item_registered_in_month("March")[0]
  end

  def test_most_sold_item_for_merchant
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_nil sa.most_sold_item_for_merchant(12334113)[0]
  end

  def test_best_item_for_merchant
    se = SalesEngine.from_csv(setup_full)
    sa = SalesAnalyst.new(se)

    assert_equal Item, sa.best_item_for_merchant(12334189).class
    assert_equal 263516130, sa.best_item_for_merchant(12334189).id
  end
end
