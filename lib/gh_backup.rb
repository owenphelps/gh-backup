require "gh_backup/version"
require 'yaml'
require 'json'
require "thor"

module GhBackup

  class Base
    
    REPO_LIMIT = 150

    def initialize(color=true)
      @color = color
    end

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
      if @color
        "\e[#{code}m#{str}\e[0m"
      else
        str
      end
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
      path = "./backups/#{now}/#{repo}"
      if Dir.exists?(path)
        puts colorize("Dir already exists. Skipping clone", 31)
      else
        system "git clone #{repo_url(username, password, account, repo)} #{path}"
      end
    end
    
    # Run all backups
    def backup(f, account, user, pass)
      repos = YAML.load_file(f).map(&:strip)
      repo_count = repos.length
      repos.each_with_index do |repo, idx|
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
    def list_org_repos(org, user, password, limit=REPO_LIMIT)
      auth = "#{user}:#{password}"
      path = "https://api.github.com/orgs/#{org}/repos?per_page=#{limit}"
      repos = `curl -u #{auth} #{path}`
      JSON.parse(repos).map do |repo|
        repo["clone_url"]
      end
    end
    
    # You can download the repos directly without having to save to YAML
    def clone_org_repos(org, user, password, limit=REPO_LIMIT)
      all_repos = list_org_repos(org, user, password, limit)
      repo_count = all_repos.length
      all_repos.each_with_index.map do |repo, i| 
        repository = split_repo_name(repo)
        puts colorize("\n#{i+1} of #{repo_count}: Cloning #{repo}", 32)
        clone_repo(user, password, org, repository)
      end
    end
  end
  
  # ===========================
  #
  # Backup CLI 
  #
  # ===========================

  class CLI < Thor
    
    def initialize(*args)
      @backup = Base.new
      super
    end

    desc "user", "Backup user repos"
    method_option :username, type: :string, aliases: '-u', required: true
    method_option :password, type: :string, aliases: '-p', required: true
    def user
      puts options.inspect
      puts options.username
    end

    desc "clone", "Clone a single repo"
    def clone(account, user, pass, repo)
      @backup.clone_repo(user, pass, account, repo)
    end

    desc "yml", "Backup all repos listed in repos.yml"
    def yml(account, user, pass)
      @backup.backup(account, user, pass)
    end

    desc "all", "Backup all repos for an org"
    def all(org, user, pass)
      @backup.clone_org_repos(org, user, pass)
    end

    desc "list", "List all repos for an organization"
    def list(account, user, pass)
      puts @backup.list_org_repos(account, user, pass)
    end
  end
end
