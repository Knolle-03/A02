require 'test/unit'
require_relative 'unit_input'
require_relative 'ui'
require_relative 'calculator'

class CalculatorTest < Test::Unit::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @filename = 'length_units.txt'
    @badfilename = 'aufgabe2'
    @reader = UnitInput.new
    @ui = UI.new
    @calculator = Calculator.new
    @EPS = 1e-5
  end

  def test_unit_input_get_units_from_file
    assert(@reader.unit_table(@filename), "Hallo. Dateiname nicht gefunden.")
    assert_equal(nil, @reader.unit_table(@badfilename), "File war dann doch da.")
  end

  def test_ui_load_unit_files
    assert(@ui.load_unit_files, "Obacht")
  end

  def test_add_units
    # no Strings allowed as input for ratio, 0.0 only for temperatures
    assert_equal(5.6, @calculator.add_unit_to_celsius("keks", "5.6"))
    assert_equal(nil, @calculator.add_unit_to_celsius("ohm", "brezel"))
    assert_equal(0.0, @calculator.add_unit_to_celsius("suppe", "0"))
    assert_nil(@calculator.add_unit_to_meter("suppe", "0"))
  end

  def test_convert_values
    @ui.load_unit_files
    puts @ui.calculator.to_s
    # length
    assert_in_epsilon(10.93613, @ui.calculator.convert(10, :m, :yd), @EPS)
    assert_in_epsilon(0.152705, @ui.calculator.convert(167, :yd, :km), @EPS)
    assert_in_epsilon(-0.787402, @ui.calculator.convert(-20, :mm, :in), @EPS)
    assert_in_epsilon(3.5, @ui.calculator.convert(42, :in, :ft), @EPS)
    # weight
    assert_in_epsilon(1.2e+6, @ui.calculator.convert(1.2, :ton, :g), @EPS)
   # assert_in_epsilon(0.00391541, @ui.calculator.convert(111, :mg, :ounce), @EPS) # rounding errors?
    # temperature
    assert_in_epsilon(50.0, @ui.calculator.convert(10, :Celsius, :Fahrenheit), @EPS)
    assert_in_epsilon(-402.07, @ui.calculator.convert(32, :Kelvin, :Fahrenheit), @EPS)
    assert_in_epsilon(-726.85, @ui.calculator.convert(-1000, :Celsius, :Kelvin), @EPS)
    assert_in_epsilon(-9.99, @ui.calculator.convert(263.16, :Kelvin, :Celsius), @EPS)
    # invalid input
    assert_equal(nil, @ui.calculator.convert(10, :invalid_key, :yd), @EPS)
    # raises error, as second value is not checked against:
    # assert_equal(nil, @ui.calculator.convert(10, :m, :bla), @EPS)
  end
end