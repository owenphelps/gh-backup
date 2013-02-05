# ===========================
#
# Backup CLI 
#
# ===========================

require "thor"
require_relative "./backup"

class CLI < Thor

  desc "user", "Backup user repos"
  method_option :username, type: :string, aliases: '-u', required: true
  method_option :password, type: :string, aliases: '-p', required: true
  def user
    puts options.inspect
    puts options.username
  end

  desc "clone", "Clone a single repo"
  def clone(username, pass, account, repo)
    backup = Backup::Base.new
    backup.clone_repo(username, pass, account, repo)
  end

  desc "list", "List all repos for an organization"
  def list(account, user, pass)
    backup = Backup::Base.new
    puts backup.list_org_repos(account, user, pass)
  end
end

