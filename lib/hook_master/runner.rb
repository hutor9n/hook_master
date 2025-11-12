# lib/hook_master/runner.rb
module HookMaster
  class Runner
    RED = "\e[31m"
    RESET = "\e[0m"

    def self.run(hook_name)
      case hook_name
      when 'pre-commit'
        run_rubocop
      else
        puts "Unknown hook: #{hook_name}. Skipping."
      end
    end

    private

    def self.run_rubocop
      puts "Running RuboCop..."

      success = system("rubocop --format p")

      unless $?.success?
        puts "#{RED} RuboCop found offenses. Commit aborted! Please fix the code.#{RESET}"
        exit(1)
      end

      puts "RuboCop passed. Continuing."
    end
  end
end
