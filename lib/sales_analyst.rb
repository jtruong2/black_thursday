require 'pry'
require_relative 'revenue'

class SalesAnalyst
  attr_reader :parent,
              :revenue

  def initialize(parent)
    @parent = parent
    @revenue = Revenue.new(self)
  end

  def average_items_per_merchant
    a = item_count_per_merchant
    value = a.values
    sum = value.reduce(:+).to_f
    leng = value.length.to_f
    average = sum / leng
    average.round(2)
  end

  def average_items_per_merchant_standard_deviation
    a = item_count_per_merchant
    value = a.values
    standard_deviation(value).round(2)
  end

  def merchants_with_high_item_count
    y = []
    a = item_count_per_merchant
    b = average_items_per_merchant_standard_deviation
    c = average_items_per_merchant
    d = @parent.merchants.contents
    a.find_all do |k,v|
      y << d[k] if v > b + c
    end
    return y
  end

  def average_item_price_for_merchant(id)
    final = []
    @parent.items.contents.each do |k,v|
      if id == v.merchant_id
        final << v.unit_price
      end
    end
     total = final.reduce(:+)/final.length
     total.round(2)
  end

  def average_average_price_per_merchant
    merchants = []
    avg_prices = []
    @parent.items.contents.each do |k,v|
      if !merchants.include?(v.merchant_id)
        merchants << v.merchant_id
      end
    end
    merchants.each do |x|
      a = average_item_price_for_merchant(x)
      avg_prices << a
    end
    a = avg_prices.reduce(:+)/avg_prices.length
    a.round(2)
  end

  def golden_items
    golden = []
    a = @parent.items.contents.values.map { |v| v.unit_price}
    b = a.reduce(:+)/a.count
    c = average_price_per_merchant_standard_deviation
    d = @parent.items.contents
    @parent.items.contents.map do |k,v|
      golden << d[k] if v.unit_price.to_f > b + (c + c)
    end
    return golden
  end

  def average_invoices_per_merchant
    a = invoice_count_per_merchant
    value = a.values
    sum = value.reduce(:+).to_f
    leng = value.length.to_f
    average = sum / leng
    average.round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    a = invoice_count_per_merchant
    value = a.values
    standard_deviation(value).round(2)
  end

  def top_merchants_by_invoice_count
    a = average_invoices_per_merchant
    b = average_invoices_per_merchant_standard_deviation
    c = invoice_count_per_merchant
    d = @parent.merchants.contents
    final = []
    c.find_all do |k,v|
      final << d[k] if v > a + (b + b)
    end
    return final
  end

  def bottom_merchants_by_invoice_count
    a = average_invoices_per_merchant
    b = average_invoices_per_merchant_standard_deviation
    c = invoice_count_per_merchant
    d = @parent.merchants.contents
    final = []
    c.each do |k,v|
      final << d[k] if v < a - (b + b)
    end
    return final
  end

  def top_days_by_invoice_count
    a = invoices_created_per_date
    b = average_invoices_created_per_day
    c = average_invoices_created_per_day_standard_deviation
    d = []
    a.each do |k,v|
      if v > b + c
        d << k
      end
    end
    return d
  end

  def invoice_status(status)
    count = count_status_orders
    total = count.values.reduce(:+)
    percentage = nil
    count.each do |k,v|
      if k == status
        percentage = v / total.to_f * 100

      end
    end
    percentage.round(2)
  end

  def total_revenue_by_date(date)
    @revenue.revenue_by_date[date]
  end

  def top_revenue_earners(x)
    @revenue.find_earners(x)
  end

  def revenue_by_merchant(merchant_id)
    @revenue.revenue_by_merchant_id[merchant_id]
  end

  def merchants_with_only_one_item
    a = compile_items_by_merchant
    b = count_items_by_merchant(a)
    c = find_associated_merchant_instances(b)
    return c
  end

  def merchants_with_only_one_item_registered_in_month(month)
    a = find_successful_invoices_by_month(month)
    c = find_merchants_from_invoices(a)
    d = get_merchant_instances_by_month(c, month)
  end

  def find_successful_invoices_by_month(month)
    @parent.invoices.all.map do |inv|
      inv if inv.is_paid_in_full? == true && inv.created_at.strftime("%B") == month
    end.compact
  end

  def find_merchants_from_invoices(array)
    array.map { |i| i.merchant_id }
  end

  def get_merchant_instances_by_month(array, month)
    instance = array.map do |i|
      @parent.merchants.find_by_id(i)
    end
    by_month = instance.delete_if { |m| m.created_at.strftime("%B") != month }
    return by_month
  end

  def most_sold_item_for_merchant(merchant_id)
    a = find_successful_invoices_by_merchant(merchant_id)
    b = invoice_items_by_invoice(a)
    c = get_revenue_for_each_invoice_item(b)
    d = find_best_seller(c)
    e = return_item_instances(d.keys)
  end

    def find_successful_invoices_by_merchant(merchant_id)
      @parent.invoices.all.map do |inv|
        inv if inv.is_paid_in_full? == true && inv.merchant_id == merchant_id
      end.compact
    end

private

  def average_price_per_merchant_standard_deviation
    a = @parent.items.contents.values.map { |v| v.unit_price}
    standard_deviation(a)
  end

  def standard_deviation(arr)
    mean = arr.reduce do |sum, element|
      sum + element
    end.to_f / arr.length
    variance = arr.reduce(0.0) do |sum, element|
      sum + (element - mean)**2
    end / (arr.length - 1)
    Math.sqrt(variance)
  end

  def item_count_per_merchant
    counts = Hash.new(0)
    x = []
    @parent.items.contents.each do |k,v|
      x << v.merchant_id
    end
    x.each do |id|
      counts[id] += 1
    end
    return counts
  end

  def invoice_count_per_merchant
    counts = Hash.new(0)
    x = []
    @parent.invoices.contents.each do |k,v|
      x << v.merchant_id
    end
    x.each do |id|
      counts[id] += 1
    end
    return counts
  end

  def days_invoice_created_at_count
    x = []
    @parent.invoices.contents.each do |k,v|
      x << v.created_at
    end
    return x
  end

  def invoices_created_per_date
    counts = Hash.new(0)
    a = days_invoice_created_at_count
    days = a.map do |x|
      x.strftime("%A")
    end
    days.each do |day|
      counts[day] += 1
    end
    return counts
  end

  def average_invoices_created_per_day
    a = invoices_created_per_date
    b = []
    a.each do |k,v|
      b << v
    end
    b.reduce(:+) / b.length
  end

  def average_invoices_created_per_day_standard_deviation
    a = invoices_created_per_date
    b = []
    a.each do |k,v|
      b << v
    end
    standard_deviation(b)
  end

  def count_status_orders
    counts = Hash.new(0)
    x = []
    @parent.invoices.contents.each do |k,v|
      x << v.status.to_sym
    end
    x.each do |id|
      counts[id] += 1
    end
    return counts
  end

  def compile_items_by_merchant
    h = {}
    a = @parent.items.contents
    a.values.each do |x|
      b = @parent.items.find_all_by_merchant_id(x.merchant_id)
      h[x.merchant_id] = b
    end
    return h
  end

  def count_items_by_merchant(hash)
    i = {}
    hash.each do |k,v|
      i[k] = v.count
    end
    return i
  end

  def find_associated_merchant_instances(hash)
    j = []
    hash.each do |k,v|
      j<< k if v == 1
    end
    @revenue.find_merchant_instances(j)
  end

  def count_invoice_items(array)
    count = {}
    array.flatten.each do |x|
      if count.keys.include?(x.invoice_id)
        count[x.invoice_id] += 1
      elsif
        count[x.invoice_id] = 1
      end
    end
    return count
  end

  def find_best_seller(hash)
    hash.select {|k,v| v == hash.values.max}
  end

  def return_item_instances(array)
    array.map do |x|
      @parent.items.find_by_id(x)
    end
  end

  def invoice_items_by_invoice(array)
    array.map do |x|
      @parent.invoice_items.find_all_by_invoice_id(x.id)
    end.flatten
  end

  def get_revenue_for_each_invoice_item(array)
    final = {}
    array.each do |x|
      final[x.item_id] = ((x.quantity) * (x.unit_price))
    end
    return final
  end

  def add_revenue_item_totals(hash)
    final = {}
    hash.each do |k,v|
      if final.keys.include?(k.invoice_id)
        final[k] += v
      elsif
        final[k] = v
      end
    end
    return final
  end

  def count_and_delete_duplicates(array)
  final = {}
  array.each do |i|
    if final.keys.include?(i)
      final[i] += 1
    elsif
      final[i] = 1
    end
  end
  return final
  end


end
