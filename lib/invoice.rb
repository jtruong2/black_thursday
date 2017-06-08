
class Invoice

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :parent

  def initialize(data, parent)
    @id          = data[:id].to_i
    @customer_id = data[:customer_id].to_i
    @merchant_id = data[:merchant_id].to_i
    @status      = data[:status].to_sym
    @created_at  = date_convert(data[:created_at])
    @updated_at  = date_convert(data[:updated_at])
    @parent      = parent
  end

  def date_convert(from_file)
    date = from_file.split("-")
    Time.new(date[0], date[1], date[2])
  end

  def merchant
    @parent.parent.merchants.find_by_id(merchant_id)
  end

  def items
    a = @parent.parent.invoice_items.find_all_by_invoice_id(id)
    b = a.map do |x|
      x.item_id
    end
    b.map do |x|
      @parent.parent.items.find_by_id(x)
    end
  end

  def transactions
    @parent.parent.transactions.find_all_by_invoice_id(id)
  end

  def customer
    @parent.parent.customers.find_by_id(customer_id)
  end

  def is_paid_in_full?
    b = transaction_status
    b.any? {|x| x == "success" ? true : false }
  end

  def total
    if is_paid_in_full?
      total_invoice_revenue(id)
    end
  end

  def transaction_status
    a = @parent.parent.transactions.contents
    list_of_transactions_for_this_invoice_id = []
    a.values.map do |v|
      if id == v.invoice_id
        list_of_transactions_for_this_invoice_id << v.result
      end
    end
    return list_of_transactions_for_this_invoice_id
  end

  def total_invoice_revenue(inv_id)
    invoice_item_contents = @parent.parent.invoice_items.all
    b = []
    d = invoice_item_contents.map do |inv_item|
      if inv_id == inv_item.invoice_id
        b << (inv_item.unit_price * inv_item.quantity).to_f
      end
    end
    b.reduce(:+)
  end
end
