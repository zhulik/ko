# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

def exec(*args) = system(args.join(" "), exception: true)
def cargo(*args) = exec("cargo", *args)

task(:fix_fmt) { cargo("fmt") }
task(:fix_cargo) { cargo("fix --allow-dirty --allow-staged") }
task(:fix_clippy) { cargo("clippy --fix --allow-dirty --allow-staged") }
task(:fix_rubocop) { exec("bundle exec rubocop -A") }
task(fix: [:fix_fmt, :fix_cargo, :fix_clippy, :fix_rubocop])

task(:check_fmt) { cargo("fmt --check") }
task(:check_clippy) { cargo("clippy") }
task(:check_rubocop) { exec("bundle exec rubocop") }
task(check: [:check_fmt, :check_clippy, :check_rubocop])

task(:compile) { cargo("build --release") }
task(spec: :compile)
task(default: [:fix, :spec, :rubocop])

task :benchmark do
  require "ko"
  require "benchmark/ips"

  arg = "arg"
  s = KO::Signals::Signal.new(:sig, [String])

  r1, r2 = Array.new(2) { -> { _1 } }

  s.connect(r1)
  s.connect(r2)

  Benchmark.ips do |x|
    x.config(time: 5, warmup: 2)

    x.report("direct call") do
      r1.call(arg)
      r2.call(arg)
    end

    x.report("signal call") { s.emit(arg) }

    x.compare!
  end
end
