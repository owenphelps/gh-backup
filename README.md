# GhBackup

A tools that backs up all github repos for an organization

![](https://raw.github.com/owainlewis/gh-backup/master/screenshots/preview.png)

## Installation

Install locally with

    $ gem install gh_backup

## Usage

Backups are placed in a folder called backups in the current directory

    backup all <org> <github-username> <github-password>
    
Backup all the git repos for your organization

```
backup list myorg username password
```

Listing all the git repos for your organization

```
backup list myorg username password
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
