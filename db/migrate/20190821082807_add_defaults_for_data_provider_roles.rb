class AddDefaultsForDataProviderRoles < ActiveRecord::Migration[5.2]
  def change
    # This migration is no longer needed.
    # DataProvider.all.each do |data_provider|
    #   data_provider.role_point_of_interest = true
    #   data_provider.role_tour = true
    #   data_provider.role_news_item = true
    #   data_provider.role_event_record = true
    #   data_provider.save
    # end
  end
end
