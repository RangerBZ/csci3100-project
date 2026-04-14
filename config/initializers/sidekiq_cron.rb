Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq::Cron::Job.create(
      name: "Daily Report - 9AM UTC (5PM HKT)",
      cron: "0 9 * * *",
      class: "DailyReportWorker",
      queue: "default"
    )
  end
end
