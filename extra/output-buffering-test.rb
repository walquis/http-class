# PURPOSE:  Explore behavior of line-buffered versus fully-buffered output.
#
# Run this script like so...
# $ ruby output-buffering-test.rb
#
# Very good.  Now run it like this...
# $ ruby output-buffering-test.rb | cat
#
# Why no output?  Ctrl-C...
# 
# Now give it an arg for "sleep":
# $ ruby output-buffering-test.rb 0.05 | cat
#
# (Wait for it...it takes a few seconds)...
#
# Why was the output delayed, and then showed up all at once?
#
# Now add "$stdout.sync = true" to the top of the file.
# Run it again, (with default 1-second sleep), but still piped to cat:
# $ ruby output-buffering-test.rb | cat
#
# So, if for example you're waiting for output to show up in a file
# using, say, "tail -f", and it's not appearing, it may be fully buffered...
# meaning, the output accumulates in the stream buffer until it fills up 
# and flushes to the downstream receiver.
#
# MORAL: Output piped to a terminal tends to default to line-buffered, while
# output directed to a pipe, file, network socket, etc may well be fully buffered.
#
while true do
  puts "Here is a Line.  Does it appear when I expect, or not?"
  secs = ARGV.empty? ? 1.0 : ARGV[0].to_f
  sleep secs
end
