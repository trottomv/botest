set :output, "./log/cron_log.log"
job_type :bin, 'cd :path && ruby ./bin/:task :output'

every 1.day, :at => '08:00 am' do
  bin :rssXkcd
end

every :hour  do
  bin :rssturnoffus
end

every '0,30 * * * *'  do
  bin :rssCal
end


