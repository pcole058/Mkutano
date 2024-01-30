# frozen_string_literal: true


raise "Already seeded" unless Decidim::Organization.count.zero?

organization = Decidim::Organization.create!(
  name: "Welcome to Voca",
  host: "localhost",
  secondary_hosts: ["127.0.0.1", "0.0.0.0"],
  description: "Development applicatioin for decidim",
  default_locale: Decidim.default_locale,
  available_locales: [:fr, :de, :en],
  reference_prefix: "DEVELOPMENT",
  available_authorizations: ["csv_census", "internal_authorization_handler"],
  users_registration_mode: :enabled,
  tos_version: Time.current,
  badges_enabled: true,
  user_groups_enabled: true,
  send_welcome_notification: true,
  file_upload_settings: Decidim::OrganizationSettings.default(:upload)
)

Decidim::User.create!(
  email: "admin@voca.city",
  name: "Administrator",
  nickname: "admin",
  password: "insecure-password",
  password_confirmation: "insecure-password",
  organization: organization,
  confirmed_at: Time.current,
  locale: I18n.default_locale,
  admin: true,
  tos_agreement: true,
  accepted_tos_version: organization.tos_version,
  admin_terms_accepted_at: Time.current
)

Decidim::System::Admin.create!(
  email: "sysadmin@voca.city",
  password: "insecure-password",
  password_confirmation: "insecure-password"
)

Decidim::System::CreateDefaultPages.call(organization)
Decidim::System::PopulateHelp.call(organization)
Decidim::System::CreateDefaultContentBlocks.call(organization)

# Give some feedback of seeding operation
puts ""
puts "Organization created? #{Decidim::Organization.count.positive? ? '✅' : 'X'}"
puts ""
puts "Admin: admin@voca.city, insecure-password"
puts "Sysadmin:sysadmin@voca.city, insecure-password"
puts ""
puts "Help page? #{Decidim::StaticPage.where(slug: 'help').count.positive? ? '✅' : 'X'}"
puts "Homepage? #{Decidim::ContentBlock.count.positive? ? '✅' : 'X'}"
puts "Terms and Conditions? #{Decidim::StaticPage.where(slug: "terms-and-conditions").count.positive? ? '✅' : 'X'}"
