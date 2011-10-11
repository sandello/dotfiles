#!/usr/bin/ruby
################################################################################
# Based on: https://github.com/ryanb/dotfiles/blob/master/Rakefile
################################################################################

require 'rake'
require 'erb'

$exclude = %w[
  bootstrap.sh
  Rakefile
  README
  README.md
]

desc "install the dotfiles into the home directory"
task :install do
  replace_all = false

  Dir['*'].each do |file|
    next if $exclude.include? file
    file = expand(file)

    if File.exist? file[:target]
      if File.identical? file[:source], file[:target]
        status :identical, file
      elsif replace_all
        do_replace file
      else
        status :overwrite, file, "? [ynaq]"
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          do_replace file
        when 'y'
          do_replace file
        when 'q'
          exit
        else
          status :skipping, file
        end
      end
    else
      do_link file
    end
  end
end

def status(what, file, extra = "")
  puts "%12s %s%s" % [ what.to_s, file[:pretty], extra ]
end

def expand(file)
  {
    :pretty => "~/.#{file.sub('.erb', '')}",
    :source => File.expand_path(File.join(ENV['PWD'], file)),
    :target => File.expand_path(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
  }
end

def do_replace(file)
  system %Q{rm -rf "#{file[:target]}"}
  do_link file
end

def do_link(file)
  if file[:source] =~ /.erb$/
    status :generating, file
    File.open(file[:target], 'w') do |new_file|
      new_file.write ERB.new(File.read(file[:source])).result(binding)
    end
  else
    status :linking, file
    system %Q{ln -s "#{file[:source]}" "#{file[:target]}"}
  end
end

