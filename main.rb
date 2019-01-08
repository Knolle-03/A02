# Aufgabe 02_1
# TeamName: NeamTame
# Author:: Lennart Draeger

# Script for handling the program logic:
# Create an instance of UI, get input from user and display the result if
# calculation was successful. Repeats until user types 'exit'
require_relative 'ui'

ui = UI.new

ui.load_unit_files
loop do
  ui.ask_for_input
  ui.display_formatted_answer if ui.calculate
  puts "Type 'exit' to exit. Type anything else to continue."
  break if gets.strip.downcase('exit')

  ui.reset
end
