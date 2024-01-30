# This migration comes from decidim_group_list (originally 20230217113049)
class AddAllowAssemblieSelfRegistration < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_assemblies, :allow_selfregistration, :boolean, null: false, default: false
  end
end
