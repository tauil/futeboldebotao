module HomeHelper
  def percent_for(number)
    return 0 if number.nan?
    number_with_precision(number, precision: 2)
  end
end
