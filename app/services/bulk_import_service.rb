require 'csv'

class BulkImportService
  attr_accessor :reporting_period, :file

  def initialize(reporting_period_id, file)
    @reporting_period = ReportingPeriod.find(reporting_period_id)
    @file = file
  end

  def log(msg)
    Rails.logger.info msg
  end

  def call
    import_data
  end

  private

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def import_data
    successes = []
    failures = []
    CSV.read(@file, headers: true).each do |row|
      next unless row.first[1]

      name = row.first[1].split(',').map(&:strip)
      user = User.where(name: [name[1], name[0]].join(' ')).first
      unless user
        log "No user found for #{row.first[1]}. Skipping..."
        next
      end
      report = @reporting_period.reports.new(user_id: user.id,
                                             role: user.role, team: user.team)

      row.to_a[1, row.size - 1].each do |pair|
        next unless pair[1]

        contract = Contract.where('name ilike ?', pair[0])
          .or(Contract.where('?=ANY(alias)', pair[0])).first

        if contract
          successes << "Found contract #{contract.name} with this value: #{pair[0]}"
        else
          failures << "Couldn't find a contract with name #{pair[0]}. Skipping..."
          next
        end
        val = pair[1].include?('%') ? pair[1].delete('%').to_f : pair[1].to_f * 100
        report.report_parts.new(contract_id: contract.id,
                                percentage: val)
      end
      report.save! if report.report_parts.any?
    end
    print_results successes, failures
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  def print_results successes, failures
    log '#####################################################'
    log ' SUCCESSES IMPORTS !!!!!! '
    successes.uniq.each do |s|
      log s
    end
    log '*****************************************************'
    log ' !!!!!! FAILURES IMPORTS !!!!!! '
    if failures.empty?
      log 'NONE'
    else
      failures.uniq.each do |s|
        log s
      end
    end
  end
end
