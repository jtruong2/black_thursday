require_relative "test_helper.rb"
require_relative "../lib/merchant"
require_relative "../lib/merchant_repository"
require_relative "../lib/sales_engine"

class MerchantTest < Minitest::Test

  attr_reader :merchant

  def setup
    @merchant = Merchant.new({:name => "GoldenRayPress",
                              :id => "12334135",
                              :created_at => "2011-12-13",
                              :updated_at => "2012-04-16"}, self)
  end

  def test_new_instance

    assert_instance_of Merchant, merchant
  end

  def test_can_access_name
    # mr = MerchantRepository.new("./test/data/merchant_fixture.csv",self)

    assert_equal "GoldenRayPress", merchant.name
  end

  def test_can_access_created_at

    assert_equal "2011-12-13 00:00:00 -0700", merchant.created_at.to_s
    assert_instance_of Time, merchant.created_at
  end

  def test_can_acces_updated_at

    assert_equal "2012-04-16 00:00:00 -0600", merchant.updated_at.to_s
    assert_instance_of Time, merchant.created_at
  end

  def test_can_access_id

    assert_equal 12334135, merchant.id
    assert_instance_of Fixnum, merchant.id
  end

end
