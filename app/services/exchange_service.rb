require 'rest-client'
require 'json'

class ExchangeService
  def initialize(source_currency, target_currency, amount)
    @source_currency = source_currency
    @target_currency = target_currency
    @amount = amount.to_f
  end


  def perform
    if @source_currency != 'BTC' && @target_currency != 'BTC'
      exchange_api_call()
    else
      return to_bitcoin() if @target_currency == 'BTC'
      return from_bitcoin() if @source_currency == 'BTC'
    end
  end

  private

    def exchange_api_call
      begin
        exchange_api_url = Rails.application.credentials[Rails.env.to_sym][:currency_api_url]
        exchange_api_key = Rails.application.credentials[Rails.env.to_sym][:currency_api_key]
        url = "#{exchange_api_url}?token=#{exchange_api_key}&currency=#{@source_currency}/#{@target_currency}"
        res = RestClient.get url
        value = JSON.parse(res.body)['currency'][0]['value'].to_f
        value * @amount
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end

    def to_bitcoin
      url = "https://blockchain.info/tobtc?currency=#{@source_currency}&value=#{@amount}"
      res = RestClient.get url
      begin
        return JSON.parse(res.body).to_f
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end

    def from_bitcoin
      begin
        url = "https://blockchain.info/ticker"
        response = RestClient.get url
        reference_value = JSON.parse(response.body)[@target_currency]["buy"].to_f
        (reference_value * @amount)
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end


end
