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
      exchange_api_key()
    else
      calc_currency_to_bitcoin() if @target_currency == 'BTC'
      if @source_currency == 'BTC'
        url = "https://blockchain.info/tobtc?currency=#{@target_currency}&value=#{1}"
        puts url
        res = RestClient.get url
        reference_value = JSON.parse(res.body).to_f
        return (reference_value * @amount)
      end
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

    def calc_currency_to_bitcoin
      url = "https://blockchain.info/tobtc?currency=#{@source_currency}&value=#{@amount}"
      res = RestClient.get url
      begin
        return JSON.parse(res.body).to_f
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    end


end
