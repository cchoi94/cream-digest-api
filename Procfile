web: bundle exec puma -p $PORT -C ./config/puma.rb
worker: worker: bundle exec sidekiq -c 2
release: rake db:migrate