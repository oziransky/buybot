namespace :auction do
  desc "Run a periodic timer that increases all active auction counters.
            If this timer has elapsed, close the auction"
  task :timer => :environment do
    logger = Log4r::Logger[Rails.env]
    # find all active auctions
    auctions = Auction.where("status = ?", Auction::ACTIVE)
    auctions.each { |auction|
      current_time = Time.now
      if (current_time <=> Time.parse(auction.close_at.to_s)) <= 0
        # two options here
        # 1. there were bids, mark the auction as checkouts and it will be handled by the controller
        # 2. no bids received, just close the auction and run background analysis
        if auction.bids_received?
          auction.status = Auction::CHECKOUT
          auction.save!
        else
          logger "Auction time out. current time : #{current_time} auction close time: #{auction.close_at}"
          auction.status = Auction::TIMEOUT
          auction.save!

          # create a background task that will handle the analysis and delete the auction
          Delayed::Job.enqueue(AuctionDeleteJob.new(auction.id))

          logger.info "Timeout auction record id:#{auction.id}"
        end
      end
    }
  end
end
