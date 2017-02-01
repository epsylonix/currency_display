require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  test "Currency should not have forced_till<[now] when force = true" do
    curr = Currency.new(
      code: 'x',
      forced_val: 5,
      forced_till: format_time(Time.zone.now - 1.second),
      forced: true
    )
    assert curr.invalid?
    assert curr.errors[:forced_till].any?
  end

  test "Currency can have forced_till < now when force = false" do
    curr = Currency.new(
      code: 'x',
      forced_val: 5,
      forced_till: format_time(Time.zone.now - 1.second),
      forced: false
    )
    assert curr.valid?
  end

  test "Currency should not have forced_val<0.01" do
    curr = Currency.new(
      code: 'x',
      forced_val: 0,
      forced_till: format_time(Time.zone.now + 1.hour),
      forced: true
    )
    assert curr.invalid?
    assert curr.errors[:forced_val].any?

    curr.forced = false
    assert curr.invalid?
    assert curr.errors[:forced_val].any?
  end

  test "Currency is valid when there is a valid code, forced_val, forced_till params" do
    curr = Currency.new(
      code: 'x',
      forced_val: 5,
      forced_till: format_time(Time.zone.now - 1.second)
    )
    assert curr.valid?
  end

  test "Currency should fetch value from source and save it in :val on fetch" do
    # also tests fetch
    # for single currency
    Currency.destroy_all
    curr = Currency.new(
      code: 'usd',
      forced_val: 5,
      forced_till: format_time(Time.zone.now + 1.hour),
    )
    curr.save

    curr.fetch!
    curr.reload
    assert curr.val > 0
    curr.destroy
  end
end
