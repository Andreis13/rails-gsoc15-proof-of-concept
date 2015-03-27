
if ENV["FS_EVENTS"] == "true"
  puts " - USING EVENTED AUTORELOAD -"

  Dir[Rails.root.join("lib/rails_autoload/**/*.rb")].each { |f| load(f) }
  listener = Listen.to(Rails.root.join('lib/rails_autoload').to_s) do |modified, added, removed|
    begin
      load(modified.first)
      puts modified
    rescue Exception => e
      pp e
    end
  end

  listener.start
end
