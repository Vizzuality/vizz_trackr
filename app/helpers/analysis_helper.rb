module AnalysisHelper

  def chart_data_from data, filter
    filter = filter.try(:to_sym) || :mean_projects
    chart_data = []
    data.each do |team_data|
       my_data = {}
       my_data[:name] = team_data[0]
       actual_data = {}
       team_data[1].each do |p|
         actual_data[p[:date]] = p[filter]
       end
       my_data[:data] = actual_data
       chart_data << my_data
    end
    chart_data
  end
end
