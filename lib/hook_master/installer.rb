# lib/hook_master/installer.rb
require 'fileutils'
require 'pathname'

module HookMaster
  class Installer

    def self.hook_content
      <<~HOOK
        #!/bin/bash
        # Hook згенеровано HookMaster
        
        # Перевіряємо, чи існує Gemfile.lock, щоб визначити, чи це Bundler-проект
        if [ -f "Gemfile.lock" ]; then
          echo "HookMaster: Running via Bundler..."
          exec bundle exec hook_master run pre-commit "\$@"
        else
          # Якщо Gemfile.lock відсутній, пробуємо запустити напряму
          echo "HookMaster: Running directly..."
          exec hook_master run pre-commit "\$@"
        fi
      HOOK
    end

    def self.install
      git_hooks_dir = File.join(Dir.pwd, '.git', 'hooks')
      hook_path = File.join(git_hooks_dir, 'pre-commit')

      unless File.directory?(git_hooks_dir)
        puts "Error: '.git/hooks/' not found. Are you in a Git repository?"
        return
      end

      script_content = self.hook_content

      File.open(hook_path, 'w') { |file| file.write(script_content) }
      FileUtils.chmod('+x', hook_path)
      puts "Success: 'pre-commit' script created (with Bundler support)."
    end

    def self.create_config
      config_filename = ".rubocop.yml"
      
      template_path = File.expand_path(
        "../../templates/#{config_filename}", 
        __dir__ 
      )
      
      if File.exist?(config_filename)
        puts "Skipping: '#{config_filename}' already exists."
        return
      end

      if File.exist?(template_path)
        FileUtils.copy_file(template_path, config_filename)
        puts "Success: Created default '#{config_filename}'."
      else
        puts "Error: Template file not found at #{template_path}"
      end
    end
    
  end
end
