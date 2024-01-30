# This migration comes from decidim_group_list (originally 20230317101257)
class AllowGroupSelfRegistrations < ActiveRecord::Migration[6.0]
  def change
    add_column :decidim_assemblies, :allow_group_selfregistration, :boolean, null: false, default: false
  end
end
