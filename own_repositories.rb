#
# Usage:
#
#   ruby own_repositories.rb ack osx
#   ruby own_repositories.rb tail Gemfile.lock
#
require 'shell'
require 'shellwords'

puts(cmd = Shellwords.shelljoin(ARGV))

repositories = %i(
  active_pstore
  acappella
  azuma
  blur_image
  death-command
  map_chain
  party-mail
  dry_require_spec_helper
)

Shell.verbose = false
sh = Shell.new
sh.pushd('.')

repositories.each do |repository|
  puts repository

  system("cd ../#{repository} && #{cmd}")
end

sh.popd
