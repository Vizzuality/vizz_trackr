module ProjectsHelper
  def td_for_burn budget, spend
    burn = budget && budget > 0.0 ? (spend/budget*100).round(2) : nil
    klass = burn ?
      (burn <= 100 ? "success" : "danger") :
      ""
    content_tag :td, class: "table-#{klass}" do
      burn ? "#{burn}%" : "-"
    end
  end
end
