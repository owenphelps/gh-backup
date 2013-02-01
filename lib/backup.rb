#!/usr/bin/env ruby

# =================================
#
# A script that will back up all git repos for 
# an organization
#
# Example
#
#   username and password must be authorized for the organization
#
#   Use: ruby backup.rb <organization> <username> <password>
#
# =================================

require 'yaml'
require 'json'

REPOS = YAML.load_file('./repos.yml').map(&:strip)

# Create a string path to a github repo with auth info
#
def repo_url(username, password, account, repo)
  "https://#{username}:#{password}@github.com/#{account}/#{repo}.git"
end

# Zip up a directory in the backups folder
def zipf(name, dir)
  system "tar zcvf #{name}.tar.gz backups/#{dir}"
end

# Colorize a string for the terminal
def colorize(str, code)
"\e[#{code}m#{str}\e[0m"
end

def make_dir(dir)
  unless Dir.exists?(dir)
    Dir.mkdir(dir) 
  end
end

# Returns current date as a string
def format_current_date
  Time.now.strftime("%m%d%Y")
end

# Clone a single repository and put it in the backups dir
# repos are saved under a folder with the current date i.e 02012014 etc
def clone_repo(username, password, account, repo)
  now = format_current_date
  make_dir("./backups")
  make_dir("./backups/#{now}")
  path = "backups/#{now}/#{repo}"
  if Dir.exists?(path)
    puts colorize("Dir already exists. Skipping clone", 31)
  else
    system "git clone #{repo_url(username, password, account, repo)} #{path}"
  end
end

# Run all backups
def backup(account, user, pass)
  repo_count = REPOS.length
  REPOS.each_with_index do |repo, idx|
    puts colorize("\n#{idx+1} of #{repo_count}: Cloning #{repo}", 32)
    clone_repo(user, pass, account, repo)  
  end
end

# Extracts the repo name from a github URL
# i.e https://github.com/boxuk/wedge.js.git
def split_repo_name(repo_path)
  parts = repo_path.split(/\//)
  parts.last.split(/.git/).first
end

# Returns an array of all the repos for an organization
def list_org_repos(org, user, password, limit=50)
  repos = `curl -u #{user}:#{password} https://api.github.com/orgs/#{org}/repos?per_page=#{limit}`
  parsed = JSON.parse(repos)
  parsed.map { |repo| repo["clone_url"] }
end

# You can download the repos directly without having to save to YAML
def clone_org_repos(org, user, password, limit=50)
  all_repos = list_org_repos(org, user, password, limit)
  repo_count = all_repos.length
  all_repos.each_with_index.map do |repo, i| 
    repository = split_repo_name(repo)
    puts colorize("\n#{i+1} of #{repo_count}: Cloning #{repo}", 32)
    clone_repo(user, pass, account, repo)
  end
end
