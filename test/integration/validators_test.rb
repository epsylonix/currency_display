class ValidatorsTest < ActiveSupport::TestCase
  test "validation regexps should validate valid values for date and currency" do
   ['10.10.2010 10:10','10/10/2010 10:10:10'].each do |val|
      assert (/#{FORM_VALIDATORS['date_rb']}/ =~ val)
    end

    ['1000,2', '1000,2050', '1000,2050', '1 000.25', '1 205 100.500'].each do |val|
      assert (/#{FORM_VALIDATORS['currency_rb']}/ =~ val)
    end
  end
end


