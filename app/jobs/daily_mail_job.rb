class DailyMailJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
    puts args
  end
end
