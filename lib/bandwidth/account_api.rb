module Bandwidth
  module AccountAPI
    def account
      account = get 'account'
      account['balance'] = account['balance'].to_f

      HashWithUnderscoreAccess.new account
    end
  end
end
