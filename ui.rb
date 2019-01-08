# Aufgabe 02_1
# TeamName: NeamTame
# Author:: Lennart Draeger

require_relative 'unit_input'
require_relative 'calculator'

# Handles user interaction and is responsible for loading the conversion tables
# to the calculator object. Stores the input values, hands them to its
# calculator, gets the result from it an displays to console.
# Also has an method to reset the input values to prepare for
class UI
  attr_reader :calculator
  def initialize
    @calculator = Calculator.new
    @file_input = UnitInput.new
    @measure = ''
    @start_unit = ''
    @target_unit = ''
    @answer = ''
  end

  def reset
    @measure = ''
    @start_unit = ''
    @target_unit = ''
    @answer = ''
  end

  def load_unit_files
    @file_input.unit_table('length_units.txt')
               .each { |line| @calculator.add_unit_to_meter(line[0], line[1]) }
    @file_input.unit_table('weight_units.txt')
               .each { |line| @calculator.add_unit_to_grams(line[0], line[1]) }
    @file_input.unit_table('temperature_units.txt')
               .each { |line| @calculator.add_unit_to_celsius(line[0], line[1]) }
  end

  def ask_for_input
    puts "Supported units:\n#{@calculator.to_s}\n"
    get_input_measure
    get_target_unit
  end

  def display_formatted_answer
    puts "#{@measure} #{@start_unit} = #{sprintf("%.4f", @answer)} #{@target_unit}"
  end

  def calculate(measure = @measure, start = @start_unit, target = @target_unit)
    if @calculator.compatible?(start, target)
      @answer = @calculator.convert(measure, start, target)
      if [:Celsius, :Fahrenheit, :Kelvin].include?(start)
        puts @calculator.include?(:Kelvin)
        if @calculator.convert(measure, start, :Kelvin) < 0
          puts 'Warning: temperature value below absolute zero'
        end
      end
      return true
    else
      puts 'Units not compatible.'
      return false
    end
  end

  private

  def get_input_measure
    loop do
      puts 'Please insert a length or weight or temperature and a unit.'
      input = gets
      @measure = input.gsub(',', '.').delete('^.0-9\-').to_f
      @start_unit = input.delete('^a-zA-Z').to_sym
      break if @calculator.include?(@start_unit)

      if @start_unit.empty?
        puts 'Missing unit'
      else
        puts "Unit not supported: #{@start_unit}"
      end
    end
  end

  def get_target_unit
    loop do
      puts 'To which measuring unit do you want to convert?'
      @target_unit = gets.strip.to_sym
      break if @calculator.include?(@target_unit)

      if @target_unit.empty?
        puts 'Missing unit'
      else
        puts "Unit not supported: #{@target_unit}"
      end
    end
  end
end
