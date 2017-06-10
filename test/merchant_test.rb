require_relative "test_helper.rb"
require_relative "../lib/merchant"
require_relative "../lib/merchant_repository"

class MerchantTest < Minitest::Test

  attr_reader :m

  def setup
    @m = Merchant.new({name:       "jejum",
                       id:         "12334141",
                       created_at: "2007-06-25",
                       updated_at: "2015-09-09"}, self)
  end

  def test_new_instance

    assert_instance_of Merchant, m
  end

  def test_can_access_name

    assert_equal "jejum", m.name
  end

  def test_can_access_created_at

    assert_equal "2007-06-25 00:00:00 -0600", m.created_at.to_s
    assert_instance_of Time, m.created_at
  end

  def test_can_acces_updated_at

    assert_equal "2015-09-09 00:00:00 -0600", m.updated_at.to_s
    assert_instance_of Time, m.updated_at
  end

  def test_can_access_id

    assert_equal 12334141, m.id
  end

end
