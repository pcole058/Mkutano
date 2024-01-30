# frozen_string_literal: true
# This migration comes from decidim_access_codes_verification (originally 20210409162973)

class CreateDecidimAccessCodesAccessCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_access_codes_access_codes do |t|
      t.references :decidim_organization, foreign_key: { to_table: :decidim_organizations }, index: { name: "index_decidim_access_codes_access_codes_organization" }
      t.string :name
      t.string :email
      t.string :code
      t.integer :maximum_uses
      t.integer :times_used, default: 0

      t.timestamps
    end
  end
end
