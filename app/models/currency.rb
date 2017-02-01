class Currency < ApplicationRecord
  after_commit :broadcast_change

  # only validates values that user can actually change
  validates :forced_val, numericality: { greater_than_or_equal_to: 0.01 }
  validate :forced_till_is_in_future

  # allows val to have spaces '1 000,50'
  # and ',' instead of '.'
  def forced_val=(val)
    if val.is_a? String
      val.gsub!(/\s+/, "")
      val.sub!(/,/, ".")
    end
    super(val)
  end

  # returns currency value fetched from it's source
  def fetch
    self.send(code + '_value')
  end

  # fetches currency value from it's source and updates the db
  def fetch!
    self.val = fetch
    self.last_updated = Time.zone.now
    self.save!
  end

  private
  # fetches exchange rate for the 'usd' currency from cbr.ru
  def usd_value
    # CBR.ru may not update exchange rate on holidays
    # so the we need the most recent exchange rate up to date.
    # It is assumed here that exchange rate is updated at least once a month
    Time.use_zone('Europe/Moscow') do
      today = Time.zone.now
      date1 = (today-1.month).strftime("%d/%m/%Y")
      date2 = today.strftime("%d/%m/%Y")
      url = "http://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=#{date1}&date_req2=#{date2}&VAL_NM_RQ=R01235"
      begin
        page = Net::HTTP::get(URI(url))
        xml = Nokogiri::XML(page)
        val = xml.xpath('//ValCurs//Record//Value').last.content
        m = val.match(/(?<rubl>\d+)(.|,)(?<cop>\d+)/)
        BigDecimal("#{m[:rubl]}.#{m[:cop]}")
      rescue StandardError => error
        # rescuing StandardError is a bad practice
        # but for the sake of a simplification
        # we don't care here if it's a timeout, 503 or the response xml is malformed
        nil
      end
    end
  end

  # runs BroadcastChangeJob when a currency is updated 
  def broadcast_change
    # don't broadcast submits from /admin when nothing changed
      BroadcastChangeJob.perform_now(self) unless previous_changes.empty?
  end
  
  def forced_till_is_in_future
    if forced_till_changed? and (!forced_till or !(/#{FORM_VALIDATORS['date_rb']}/ =~ forced_till_before_type_cast))
      # datetime typecast will make date of everything (even a string with no digits) 
      # so we have to enforce datetime format
      errors.add(:forced_till, I18n.t("is not a valid time (date)")+" (#{forced_till_before_type_cast})") 
    elsif forced and forced_till < Time.zone.now
      # don't allow forced value to be set when the time for it to be reset
      # has already passed
      errors.add(:forced_till, I18n.t('time has already passed! Please choose time in the future.')) 
    end
  end

end