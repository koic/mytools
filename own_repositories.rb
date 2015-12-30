#
# Usage:
#
#   ruby own_repositories.rb ack osx
#   ruby own_repositories.rb tail Gemfile.lock
#
require 'shellwords'

puts(cmd = ARGV[0])
puts(cmd_arg = ARGV[1])

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

  system("cd ../#{repository} && #{Shellwords.shellescape(cmd)} #{Shellwords.shellescape(cmd_arg)}")
end

system('popd')
