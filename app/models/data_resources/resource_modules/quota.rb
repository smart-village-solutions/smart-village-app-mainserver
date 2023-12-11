class Quota < ApplicationRecord
  # Plural von quota ist leider quota in Rails auch wenn deepl.com das anders sieht
  self.table_name = "quotas"

  belongs_to :quotaable, polymorphic: true

  # Einlösefrequenz: einmalig, wöchentlich, monatlich, jährlich
  enum frequency: { once: 0, weekly: 1, monthly: 2, yearly: 3 }, _prefix: true
end
