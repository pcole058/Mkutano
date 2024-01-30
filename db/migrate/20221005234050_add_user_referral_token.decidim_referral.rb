# This migration comes from decidim_referral (originally 20220718124344)
class AddUserReferralToken < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_users, :referral_token, :string
    Decidim::User.all.each do |user|
      user.set_referral_token!
      user.save
    end
  end
end
