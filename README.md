# README

## Reach out to me at : phani.vakicherla@gmail.com

TO start the app:

```
docker-compose up
```

If first time please do the following steps
```
docker-compose build
docker-compose run web bundle exec rails db:create
docker-compose run web bundle exec rails db:migrate
docker-compose run web bundle exec rails db:seed  
```
