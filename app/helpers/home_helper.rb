# coding: utf-8
module HomeHelper
  def percent_for(number)
    return 0 if number.nan?
    number_with_precision(number, precision: 2)
  end

  def comparison_year
    return '2016' if params[:year].nil?
    return 'tudo jogado até o momento' if params[:year] == 'all'
    params[:year]
  end
end
