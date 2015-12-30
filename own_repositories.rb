#
# Usage:
#
#   ruby own_repositories.rb ack osx
#   ruby own_repositories.rb tail Gemfile.lock
#
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

system('pushd .')

repositories.each do |repository|
  puts repository

  system("cd ../#{repository} && #{cmd}")
end

system('popd')
