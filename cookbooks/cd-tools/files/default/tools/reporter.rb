#!/opt/chef/embedded/bin/ruby

# my message is all of the command line args
msg = ARGV.join(" ")

# report formatters
columns = 40

left_margin = "<!==="
right_margin = "===!>"
header_char = "="
footer_char = "="

# create report
header = left_margin + "#{header_char}"*(columns + 2) + right_margin
footer = left_margin + "#{footer_char}"*(columns + 2) + right_margin

sized = `echo '#{msg}' | fmt -w #{columns}`

centered = sized.split("\n").map do |lines|
  "#{left_margin} #{lines.center(columns)} #{right_margin}\n"
end

puts header
puts centered
puts footer
