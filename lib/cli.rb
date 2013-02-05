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
  def clone(account, user, pass, repo)
    backup = Backup::Base.new
    backup.clone_repo(user, pass, account, repo)
  end

  desc "yml", "Backup all repos listed in repos.yml"
  def yml(account, user, pass)
    backup = Backup::Base.new
    backup.backup(account, user, pass)
  end

  desc "all", "Backup all repos for an org"
  def all(org, user, pass)
    backup = Backup::Base.new
    backup.clone_org_repos(org, user, pass)
  end

  desc "list", "List all repos for an organization"
  def list(account, user, pass)
    backup = Backup::Base.new
    puts backup.list_org_repos(account, user, pass)
  end
end

