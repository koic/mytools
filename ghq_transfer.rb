#
# Transfer to ghq convention directory layout
#
# Usage:
#
#   ruby ghq_transfer.rb
#
# Options:
#
#   * dry run mode (default) ... ruby ghq_transfer.rb
#   * debug mode             ... DEBUG=true ruby ghq_transfer.rb
#   * apply mode             ... VALTH=true ruby ghq_transfer.rb
#
# Example effect:
#
#   /Users/account/.ghq/rabbit -> /Users/account/.ghq/github.com/rabbit-shocker/rabbit
#   /Users/account/.ghq/racc -> /Users/account/.ghq/github.com/tenderlove/racc
#   /Users/account/.ghq/rack -> /Users/account/.ghq/github.com/rack/rack
#   /Users/account/.ghq/rack-attack -> /Users/account/.ghq/github.com/kickstarter/rack-attack
#   /Users/account/.ghq/rack-cache -> /Users/account/.ghq/github.com/rtomayko/rack-cache
#   /Users/account/.ghq/rack-mini-profiler -> /Users/account/.ghq/github.com/MiniProfiler/rack-mini-profiler
#   /Users/account/.ghq/rack-pjax -> /Users/account/.ghq/github.com/eval/rack-pjax
#   /Users/account/.ghq/rack-protection -> /Users/account/.ghq/github.com/rkh/rack-protection
#   /Users/account/.ghq/rack-test -> /Users/account/.ghq/github.com/brynary/rack-test
#   /Users/account/.ghq/rails -> /Users/account/.ghq/github.com/rails/rails
#
require 'fileutils'
require 'pathname'
require 'uri'

def extract_paths_from_ssh(url)
  /git@(.+):(.+)\/(.+)/ === url

  host = $1
  user = $2
  repo = $3

  repo.gsub!(/\.git$/, '') if repo

  [host, user, repo]
end

def extract_paths_from_https(url)
  uri = URI.parse(url)

  host = uri.host
  _, user, repo = uri.path.split('/')
  repo.gsub!(/\.git$/, '')

  [host, user, repo]
end

ghq_root = Pathname(`ghq root`.chomp)

Dir.glob(ghq_root.join('*')).each do |src|
  next unless File.ftype(src) == 'directory'

  puts "[DEBUG] #{src}" if ENV['DEBUG'] == 'true'

  Dir.chdir(src)

  origin_url = `git config --get remote.origin.url`

  next if origin_url.empty?

  origin_url.chomp!

  host, user, repo = if /^git@.+/ === origin_url
    extract_paths_from_ssh(origin_url)
  else
    extract_paths_from_https(origin_url)
  end

  begin
    dest_dir = ghq_root.join(host, user)
    dest_path = dest_dir.join(repo)

    puts "#{src} -> #{dest_path}"

    if ENV['VALTH'] == 'true'
      FileUtils.mkdir_p(dest_dir)

      FileUtils.mv(src, dest_path)
    end
  rescue
    puts "[SKIP] #{src}"
  end
end
