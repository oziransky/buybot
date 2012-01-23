set :cron_log, "~/cron_log.log"

# run auction timers every 30 seconds to update the close time
every 1.minute do
  rake "auction:timer", :environment => :development
end

# start the delayed job process
every :reboot do
  rake "jobs:clear", :environment => :development
  rake "jobs:work", :environment => :development
end