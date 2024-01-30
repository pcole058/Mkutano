# frozen_string_literal: true
source "https://rubygems.org"
ruby RUBY_VERSION

gem "decidim",
    git: "https://github.com/octree-gva/decidim-lts",
    branch: "lts/0.26.4"
gem "decidim-conferences",
  git: "https://github.com/octree-gva/decidim-lts",
  branch: "lts/0.26.4",
  glob: "decidim-conferences/*.gemspec"
gem "decidim-templates",
  git: "https://github.com/octree-gva/decidim-lts",
  branch: "lts/0.26.4",
  glob: "decidim-templates/*.gemspec"

gem "bootsnap", "~> 1.3"
gem "puma", ">= 6.1"
gem "faker", "~> 2.14"
gem "sidekiq", "~> 6.2", ">= 6.2.1"
gem "hiredis", "~> 0.6.3"
gem "redis", ">= 4.1"

gem "wicked_pdf", "~> 2.1"
require File.join('/home/decidim/app/lib/decidim/voca.rb')
Decidim::Voca.each_gem do |gem_config, gem_attributes| 
  gem *gem_config, **gem_attributes
end
