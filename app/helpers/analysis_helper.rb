module AnalysisHelper

  def line_chart_data data, filter
    filter = filter.try(:to_sym) || :mean
    chart_data = []
    [:K, :Rosling].each do |team|
      hsh = { name: team.to_s }
      actual_data = {}
      data.each do |dt|
        actual_data[dt[:rp].display_name] = dt[team][filter]
      end
      hsh[:data] = actual_data
      chart_data << hsh
    end
    chart_data
  end
end
