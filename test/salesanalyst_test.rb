require_relative 'test_helper.rb'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'
require 'pry'
class SalesAnalystTest < Minitest::Test
  def setup
    {:items=>"./data/items.csv",:merchants => "./data/merchants.csv",:invoices =>"./data/invoices.csv",:invoice_items=>"./data/invoice_items.csv",:transactions=>"./data/transactions.csv",:customers=>"./data/customers.csv"}
  end

  # def test_it_exists
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_instance_of SalesAnalyst, sa
  # end
  #
  # def test_retrieve_average_items_per_merchant
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 2.88 ,sa.average_items_per_merchant
  # end
  #
  # def test_retrieve_average_items_per_merchant_standard_deviation
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 3.26 ,sa.average_items_per_merchant_standard_deviation
  # end
  #
  # def test_retrieve_merchants_with_high_item_count
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #   a = sa.merchants_with_high_item_count
  #
  #   assert_equal "FlavienCouche" ,a[0].name
  # end
  #
  # def test_retrieve_average_item_price_for_merchant
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #
  #   assert_equal 10.78 ,sa.average_item_price_for_merchant(12334185).to_f
  # end
  #
  # def test_average_average_price_per_merchant
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 350.29, sa.average_average_price_per_merchant.to_f
  # end
  #
  # def test_retrieve_golden_items
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #   a = sa.golden_items
  #
  #   assert_equal "Test listing", a[0].name
  # end
  #
  # def test_average_invoices_per_merchant
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 10.49, sa.average_invoices_per_merchant
  # end
  #
  # def test_average_invoices_per_merchant_standard_deviation
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 3.29, sa.average_invoices_per_merchant_standard_deviation
  # end
  #
  # def test_top_merchants_by_invoice_count
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #   a = sa.top_merchants_by_invoice_count
  #
  #   assert_equal "Chemisonodimenticato", a[0].name
  # end
  #
  # def test_bottom_merchants_by_invoice_count
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #   a = sa.bottom_merchants_by_invoice_count
  #
  #   assert_equal "WellnessNeelsen", a[0].name
  # end
  #
  # def test_top_days_by_invoice_count
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal ['Wednesday'], sa.top_days_by_invoice_count
  # end
  #
  # def test_invoice_status
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 29.55, sa.invoice_status(:pending)
  #   assert_equal 56.95, sa.invoice_status(:shipped)
  #   assert_equal 13.5, sa.invoice_status(:returned)
  # end
  #
  # def test_total_revenue_by_date
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #
  #   assert_equal 818.1,sa.total_revenue_by_date("2009-04-22")
  # end
  #
  # def test_top_revenue_earners
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #   sa.revenue.merchant_revenue
  #
  #   assert_equal 5, sa.top_revenue_earners(5).length
  #   assert_equal 20, sa.top_revenue_earners("whatever").length
  #   assert_instance_of Merchant, sa.top_revenue_earners(5)[0]
  # end
  #
  # def test_revenue_by_merchant
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 18631.46, sa.revenue_by_merchant(12335938).to_f
  #   assert_instance_of BigDecimal, sa.revenue_by_merchant(12335938)
  # end
  #
  # def test_merchants_with_only_one_item
  #   se = SalesEngine.from_csv(setup)
  #   sa = SalesAnalyst.new(se)
  #
  #   assert_equal 243, sa.merchants_with_only_one_item.length
  #   assert_instance_of Merchant, sa.merchants_with_only_one_item[0]
  # end

  def test_merchants_with_only_one_item_registered_in_month
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 20, sa.merchants_with_only_one_item_registered_in_month("March").length
  end

  def test_most_sold_item_for_merchant
    skip #need to look for successful invoices
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_equal 1, sa.most_sold_item_for_merchant(12334189).count
    assert_instance_of Item, sa.most_sold_item_for_merchant(12334189)[0]
    assert_equal 263500432, sa.most_sold_item_for_merchant(12334189)[0].id
    assert sa.most_sold_item_for_merchant(12334296).include?(263549386)
    assert_equal 4, sa.most_sold_item_for_merchant(12337105).length
  end

  def test_best_item_for_merchant
    skip
    se = SalesEngine.from_csv(setup)
    sa = SalesAnalyst.new(se)

    assert_instance_of Item, sa.best_item_for_merchant(12334863)
    assert_equal 263500208, sa.best_item_for_merchant(12334189).id
  end


end
