# Activate auto-completion.
require "irb/completion"

# Use the simple prompt if possible.
IRB.conf[:PROMPT_MODE] = :SIMPLE

if !defined?(RUBY_ENGINE) || RUBY_ENGINE != "rbx"
  begin
    require "rubygems"
  rescue LoadError
    warn("Could not load RubyGems.")
  end
  if RUBY_VERSION =~ /^1\.[89]\..$/
    begin
      require "pp"
      require "benchmark"

      if File.exist?("lib")
        $:.unshift(File.expand_path("lib"))
        $:.uniq!
      end

      load("/etc/irbrc") if File.exist?("/etc/irbrc")
    rescue Exception => error
      STDERR.puts "Error in .irbrc:"
      STDERR.puts "#{error.class.name}: #{error.message}"
      if error.respond_to?(:backtrace)
        STDERR.puts "#{error.backtrace.join("\n")}"
      end
    end
  end
end
