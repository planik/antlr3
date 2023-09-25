class String
  # Returns the shortest length of leading whitespace for all non-blank lines
  #
  #   n = %Q(
  #     a = 3
  #       b = 4
  #   ).level_of_indent  #=> 2
  def level_of_indent
    scan(/^ *(?=\S)/).map { |space| space.length }.min || 0
  end

  # removes current level of indent and then indents +n+ spaces
  def fixed_indent(n)
    outdent(level_of_indent).indent(n)
  end
end
