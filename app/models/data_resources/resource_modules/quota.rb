class Quota < ApplicationRecord
  # Plural von quota ist leider quota in Rails auch wenn deepl.com das anders sieht
  self.table_name = "quotas"

  belongs_to :quotaable, polymorphic: true
  has_many :redemptions, as: :redemable, dependent: :destroy

  # Einlösefrequenz: einmalig, wöchentlich, monatlich, jährlich
  enum frequency: { once: 0, daily: 1, weekly: 2, monthly: 3, quarterly: 4, yearly: 5 }, _prefix: true
  enum visibility: { private_visibility: 0, public_visibility: 1 }

  # Number of maximum redemptions
  #
  # max_quantity minus "Number of redemptions" within the given time period
  # depending on the redemption frequency
  def available_quantity
    max_quantity.to_i - current_redemptions_for_frequency.count.to_i
  end

  def available_quantity_for_member(member_id: nil) # rubocop:disable Metrics/MethodLength
    return nil if member_id.blank?

    # gibt es insgesamt noch Quota?
    current_available_quantity = available_quantity
    return 0 if current_available_quantity <= 0

    # Ist ein Maximum pro Person definiert und gibt es noch Quota für den Member?
    if max_per_person.present?
      # Anzahl der Einlösungen eines konkreten Members im gegebenen Zeitraum je nach Einlösefrequenz
      member_redemptions_count = current_redemptions_for_frequency.where(member_id: member_id).count
      return 0 if member_redemptions_count >= max_per_person.to_i
      return 0 if current_available_quantity < member_redemptions_count

      # Theoretisch maximale Anzahl an Einlösungen minus der Anzahl der Einlösungen des Members im gegebenen Zeitraum
      # bsp. 10 Sind verfügbar, Max 2 Pro member und Member hat 1 bisher verwendet => 1 ist verfügbar
      # bsp. 1 Sind verfügbar, Max 2 Pro member und Member hat 1 bisher verwendet => 1 ist verfügbar
      # bsp. 1 Sind verfügbar, Max 1 Pro member und Member hat 1 bisher verwendet => 0 ist verfügbar
      # bsp. 1 Sind verfügbar, Max 10 Pro member und Member hat 2 bisher verwendet => 1 ist verfügbar
      current_available_per_member = max_per_person - member_redemptions_count
      return 0 if current_available_per_member.zero?
      return current_available_per_member if current_available_quantity >= current_available_per_member
    end

    current_available_quantity
  end

  # check if member has available quota for redemption
  #
  # @param [Integer] member_id ID of member
  # @param [Integer] quantity Quantity to be redeemed
  #
  # @return [Boolean] true if member has available quota for redemption
  def available_quota_for_redemption_valid?(member_id, quantity)
    max_available_quota = available_quantity_for_member(member_id: member_id)
    return false if max_available_quota.nil?
    return true if quantity <= max_available_quota

    false
  end

  # attribute quantity in redemption represents number of simultaneous redemptions
  def redeem!(member_id, quantity)
    quantity.to_i.times { redemptions.create!(member_id: member_id, quantity: quantity) }
  end

  private

    def current_redemptions_for_frequency # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      case frequency
      when "once"
        redemptions.all
      when "daily"
        redemptions.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
      when "weekly"
        redemptions.where(created_at: Time.zone.now.beginning_of_week..Time.zone.now.end_of_week)
      when "monthly"
        redemptions.where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
      when "quarterly"
        redemptions.where(created_at: Time.zone.now.beginning_of_quarter..Time.zone.now.end_of_quarter)
      when "yearly"
        redemptions.where(created_at: Time.zone.now.beginning_of_year..Time.zone.now.end_of_year)
      end
    end
end

# == Schema Information
#
# Table name: quotas
#
#  id             :bigint           not null, primary key
#  max_quantity   :integer
#  frequency      :integer
#  max_per_person :integer
#  quotaable_type :string(255)
#  quotaable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
