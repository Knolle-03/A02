# Aufgabe 02_1
# TeamName: NeamTame
# Author:: Lennart Draeger

# Reads unit table from a file. Returns couples of units and corresponding
# factors as an array. Ignores empty lines and comments.
class UnitInput
  def unit_table(filename)
    return puts "File not found: #{filename}" unless File.file?(filename)

    lines = []
    file = File.open(filename)
    file.each do |line|
      ary = line.split(' ')
      lines.push(ary) if ary.size == 2
    end
    file.close
    lines
  end
end
