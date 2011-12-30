namespace :auction do
  desc "Run a periodic timer that increases all active auction counters.
            If this timer has elapsed, close the auction"
  task :timer => :environment do
    logger = Log4r::Logger[Rails.env]
    puts "Running timer"
    # find all active auctions
    auctions = Auction.where("status = ?", Auction::ACTIVE)
    auctions.each { |auction|
      if (Time.now <=> Time.parse(auction.close_at.to_s)) <= 0
        auction.status = Auction::TIMEOUT
        auction.save!
        logger.info "Timeout auction record id:#{auction.id}"
      end
    }
  end
end