# Aufgabe 02_1
# TeamName: NeamTame
# Author:: Lennart Draeger

# Converts a value from one unit of measurement to another. First Checks, which
# system to use, then call the corresponding method. Contains methods to add
# new units and factors, check if a unit is supported or if two units are
# compatible, e.g. if they are using the same system.
class Calculator
  def initialize
    @to_meter = {}
    @to_grams = {}
    @to_celsius = {}
  end

  def add_unit_to_meter(unit, factor)
    @to_meter.store(unit.to_sym, factor.to_f) unless factor.to_f.zero?
  end

  def add_unit_to_grams(unit, factor)
    @to_grams.store(unit.to_sym, factor.to_f) unless factor.to_f.zero?
  end

  def add_unit_to_celsius(unit, factor)
    @to_celsius.store(unit.to_sym, factor.to_f) unless factor.delete('^.,0-9\-').empty?
  end

  def convert(number, start_unit, target_unit)
    if @to_meter.include?(start_unit)
      convert_length(number, start_unit, target_unit)
    elsif @to_grams.include?(start_unit)
      convert_weight(number, start_unit, target_unit)
    elsif @to_celsius.include?(start_unit)
      convert_temperature(number, start_unit, target_unit)
    end
  end

  def include?(unit)
    @to_meter.key?(unit) || @to_grams.key?(unit) || @to_celsius.key?(unit)
  end

  def compatible?(unit1, unit2)
    if @to_meter.include?(unit1)
      @to_meter.include?(unit2)
    elsif @to_grams.include?(unit1)
      @to_grams.include?(unit2)
    elsif @to_celsius.include?(unit1)
      @to_celsius.include?(unit2)
    else
      false
    end
  end

  def to_s
    units = ''
    all_units = { length: @to_meter, weight: @to_grams, temperature: @to_celsius }
    all_units.each_pair do |category, measurement_system|
      units << "#{category}: "
      measurement_system.each_key { |key| units << "#{key}, " }
      units.delete_suffix!(', ') << "\n"
    end
    units
  end

  private

  def convert_length(distance, start_unit, target_unit)
    distance * @to_meter[start_unit] * 1 / @to_meter[target_unit]
  end

  def convert_weight(weight, start_unit, target_unit)
    weight * @to_grams[start_unit] * 1 / @to_grams[target_unit]
  end

  def convert_temperature(temperature, start_unit, target_unit)
    temp = temperature - @to_celsius[start_unit]
    temp *= 5.0 / 9.0 if start_unit == :Fahrenheit
    temp += @to_celsius[target_unit]
    temp = (temp * 9.0 / 5.0) - (128.0 / 5.0) if target_unit == :Fahrenheit
    temp
  end
end
