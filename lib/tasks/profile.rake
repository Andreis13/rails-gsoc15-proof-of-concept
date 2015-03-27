namespace :profile do
  desc "TODO"
  task :rails_autoreload do
    require 'fileutils'
    require 'net/http'
    require 'benchmark'

    def foo
      Net::HTTP.get("localhost", "/foo", 3000)
    end
    def touch_foo
      FileUtils.touch("lib/rails_autoload/foo_1/baz.rb")
    end

    n = 100

    Benchmark.bm(30) do |results|
      results.report("no file modifications:") do
        n.times { foo }
      end

      results.report("autoreloading modified files:") do
        n.times { touch_foo; foo }
      end
    end
  end
end
