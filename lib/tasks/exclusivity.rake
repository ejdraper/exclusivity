require "fileutils"

namespace :exclusivity do
  namespace :install do
    desc "This copies over and installs all migrations"
    task :migrations do
      # Build our app migration path
      path = File.join("db", "migrate")
      # Build the full source path based on the plugin
      source = File.join(RAILS_ROOT, "vendor", "plugins", "exclusivity", path)
      # And the full destination path based on the app root
      destination = File.join(RAILS_ROOT, path)
      puts "INSTALLING: #{path} - from #{source} to #{destination}"
      # Copy over all files found
      Dir.glob(File.join(source, "*")).each do |f|
        filename = File.join(destination, File.basename(f))
        unless File.exists?(filename)
          puts "COPYING: #{f} to #{filename}"
          FileUtils.cp f, filename
        end
      end
    end
  end
  
  namespace :invites do
    desc "Create 10 new dummy invites for use on the site for testing"
    task :create => :environment do
      # Loop through and create 10 new invites, outputting the invite codes to the console
      1.upto(10) do
        puts "CREATED: invite #{Invite.create!.slug}"
        sleep 1
      end
    end
  end
end