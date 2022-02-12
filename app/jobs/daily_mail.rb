class DailyMail
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    puts "hello world"
  end
end
