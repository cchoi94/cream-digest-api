web: bundle exec puma -p $PORT -C ./config/puma.rb
worker: bundle exec sidekiq -c 2
release: rails db:migrate