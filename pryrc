`which subl`; Pry.config.editor = "subl" if $?.success?

begin
  require "awesome_print"
  Pry.config.print = proc { |output, value| output.puts "=> #{ap value}" }
rescue LoadError
  puts "=> Unable to load awesome_print, please type 'gem install awesome_print'."
end
