# lib/hook_master/installer.rb
require 'fileutils'

module HookMaster
  class Installer
    def self.install
      git_hooks_dir = File.join(Dir.pwd, '.git', 'hooks')
      hook_path = File.join(git_hooks_dir, 'pre-commit')

      unless File.directory?(git_hooks_dir)
        puts "Error: '.git/hooks/' not found. Are you in a Git repository?"
        return
      end

      script_content = <<~SHELL
        #!/bin/bash
        hook_master run pre-commit "$@"
      SHELL

      File.open(hook_path, 'w') { |file| file.write(script_content) }
      FileUtils.chmod('+x', hook_path)
      puts "Success: 'pre-commit' script created."
    end
  end
end
