require_relative 'merchant'
require 'pry'

class SalesEngine

  attr_reader :items,
              :merchants

  def intialize
    @items = ItemRepository.new
    @merchants = MerchantRepository.new
  end

  def self.from_csv(file)
  end


# binding.pry
  # def items
  #
  # end
  #
  # def merchants
  #
  # end

  # def self.from_csv(files)
  #
  # end


end
