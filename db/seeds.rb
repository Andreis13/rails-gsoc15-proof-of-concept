# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


(1..1000).each do |i|
  path = Rails.root.join("lib/rails_autoload/foo_#{i}")
  FileUtils.mkdir(path) unless Dir.exist? path
  File.open(path.join("bar.rb"), "w") do |file|
    file.write <<-text
module Foo_#{i}
  class Bar
    def self.inspect
      "I'm Foo #{i}"
    end
  end
end
    text
  end
end
