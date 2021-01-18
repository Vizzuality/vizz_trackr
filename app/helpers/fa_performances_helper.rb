module FaPerformancesHelper
  def difference_color pro, con
    pro - con >= 0 ? 'success' : 'danger'
  end
end
