# This migration comes from decidim_group_list (originally 20220901175244)
class CreateComponentsUserGroup < ActiveRecord::Migration[5.0]
  def change
    create_table :decidim_components_user_group do |t|
      t.references :decidim_components, null: false, index: true
      t.references :decidim_user_group, null: false, index: true

      t.timestamps
    end

    add_index :decidim_components_user_group, [:decidim_components_id, :decidim_user_group_id], unique: true, name: "decidim_components_user_group_unique_user_and_group_ids"
  end
end