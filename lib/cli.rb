require "thor"

class CLI < Thor

  desc "user", "Backup user repos"
  method_option :username, type: :string, aliases: '-u', required: true
  method_option :password, type: :string, aliases: '-p', required: true
  def user
    puts options.inspect
    puts options.username
  end

  desc "org", "Backup all github repos for an organization"
  method_option :username, type: :string, aliases: '-u', required: true
  method_option :password, type: :string, aliases: '-p', required: true
  def org
    puts options.inspect
    puts options.username
  end
end

