module ProjectStacksHelper
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Lint/UnusedMethodArgument
  def stack_chart_data data, filter
    [
      {
        name: 'Prep',
        data: {
          "October '18" => 23,
          "November '18" => 23
        },
        stack: 'Rosling'
      },
      {
        name: 'GFW',
        data: {
          "October '18" => 23,
          "November '18" => 23
        },
        stack: 'K'
      },
      {
        name: 'Half-Earth',
        data: {
          "October '18" => 23,
          "November '18" => 21
        },
        stack: 'Rosling'
      }
    ]
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Lint/UnusedMethodArgument
end
