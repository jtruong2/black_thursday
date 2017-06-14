require 'pry'


class Revenue
  attr_reader :parent,
              :revenue_by_date,
              :revenue_by_merchant_id

  def initialize(parent)
    @parent = parent
    @revenue_by_date = {}
    @revenue_by_merchant_id = {}
    @start = extract_date_and_revenue; extract_merchants_and_revenues
  end

  def extract_date_and_revenue
    access_invoice_items.values.each do |v|
      a = date_convert(v.created_at)
      b = v.unit_price * v.quantity
      if revenue_by_date.has_key?(v.created_at)
        @revenue_by_date[a] += (v.unit_price * v.quantity)
      else
        @revenue_by_date[a] = b
      end
    end
  end

  def extract_merchants_and_revenues
    merchant_id_and_sales = {}
    access_invoices.values.map do |inv|
      invoice_total = inv.total
      next if invoice_total == nil
      if merchant_id_and_sales.has_key?(inv.merchant_id)
        merchant_id_and_sales[inv.merchant_id] += invoice_total
      else
        merchant_id_and_sales[inv.merchant_id] = invoice_total
      end
    end
    a = merchant_id_and_sales.each {|k,v| @revenue_by_merchant_id[k] = v}
  end

  def merchant_revenue
    arrange = @revenue_by_merchant_id.invert.to_a
    arrange.sort!
    arrange.reverse!
    arrange.transpose[1]
  end

  def find_earners(x)
    a = merchant_revenue
    if x.class == Fixnum || x.class == Integer
      b = a.shift(x)
    else
      b = a.shift(20)
    end
    find_merchant_instances(b)
  end

  def find_merchant_instances(arr)
    final = []
    arr.each do |x|
      final << merchant_to_instance_conversion(x)
    end
    final
  end

  def find_merchants_with_unpaid_invoices
    pending_invoices = @parent.parent.invoices.all.map do |inv|
      inv.merchant_id if inv.is_paid_in_full? == false
    end
    pending_invoices.uniq.map do |m_id|
      merchant_to_instance_conversion(m_id)
    end
  end

  def find_best_item_for_merchant(m_id)
    successful_invoices = @parent.parent.invoices.all.map do |inv|
      inv if inv.is_paid_in_full? == true
    end
    merchant_inv = successful_invoices.compact.delete_if do |inv|
      m_id != inv.merchant_id
    end
    merchant_inv.map do |inv|
      revenue_per_item(inv)
    end

  end


private

  def invoices_link
    @parent.parent.invoices
  end

  def date_convert(date)
   date.strftime "%Y-%m-%d"
  end

  def access_invoice_items
    @parent.parent.invoice_items.contents
  end

  def access_invoices
    @parent.parent.invoices.contents
  end

  def access_merchants
    @parent.parent.merchants.contents
  end

  def invoice_to_merchant_conversion(inv)
    access_invoices.values.each do |v|
      if v.id == inv
        return v.merchant_id
      end
    end
  end

  def merchant_to_instance_conversion(m_id)
    access_merchants.values.find do |v|
      if v.id == m_id
        return v
      end
    end
  end

  def revenue_per_item(inv)
    @parent.parent.invoice_items.all.map do |inv_items|
      if inv.id == inv_items.invoice_id
        return (inv_items.unit_price * inv_items.quantity)
      end
    end
  end
end
