module ApplicationHelper
  def idr(amount) = number_to_currency(amount, unit: "Rp ", delimiter: ".", separator: ",", precision: 0)
end
