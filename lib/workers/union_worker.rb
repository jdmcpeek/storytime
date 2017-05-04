class UnionWorker
  include Sidekiq::Worker
  def perform
    while true
      puts "striking.... striking.... striking...."
      sleep 10
    end
  end
end