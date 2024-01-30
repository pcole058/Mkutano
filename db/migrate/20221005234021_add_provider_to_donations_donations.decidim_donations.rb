# frozen_string_literal: true
# This migration comes from decidim_donations (originally 20210708141815)

class AddProviderToDonationsDonations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_donations_donations, :method, :string
  end
end
