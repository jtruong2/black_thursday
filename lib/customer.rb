
class Customer

  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at

  def initialize(data, parent)
    @id         = data[:id]
    @first_name = data[:first_name]
    @last_name  = data[:last_name]
    @created_at = date_convert(data[:created_at])
    @updated_at = date_convert(data[:updated_at])
    @parent     = parent
  end

  def date_convert(file_data)
    date = file_data.split(/[-," ",:]/)
    time = Time.utc(date[0], date[1], date[2], date[3], date[4],
                    date[5], date[6], date[7])
  end

end