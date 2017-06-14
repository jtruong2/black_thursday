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
    invoice_id_and_sales = {}
    access_invoices.values.map do |inv|
      invoice_total = inv.total
      next if invoice_total == nil
      if invoice_id_and_sales.has_key?(inv.id)
        invoice_id_and_sales[inv.id] += invoice_total
      else
        invoice_id_and_sales[inv.id] = invoice_total
      end
    end
    replace_invoice_id_with_merchant_id(invoice_id_and_sales)
  end

  def replace_invoice_id_with_merchant_id(hash)
    hash.each do |k,v|
      a = invoice_to_merchant_conversion(k)
      @revenue_by_merchant_id[a] = v
    end
  end

  def merchant_revenue
    a = @revenue_by_merchant_id
    b = a.invert.to_a
    b.sort!
    b.reverse!
    c = b.transpose
    c[1]
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
      a = merchant_to_instance_conversion(x)
      final << a
    end
    final
  end


# private

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
end
