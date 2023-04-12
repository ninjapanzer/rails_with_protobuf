SHELL := /bin/sh

run:
	@bundle exec rails s

console:
	@bundle exec rails c

test:
	@bundle exec rails test

asdf-setup:
	asdf plugin add ruby || true
	asdf plugin add protoc || true
	asdf install ruby
	asdf install protoc

setup:
	bundle config set --local path 'vendor/bundle'
	bundle install
	@bundle exec rails db:schema:load

migrate:
	@bundle exec rails db:migrate

compile-proto:
	@protoc --ruby_out=app/protos --proto_path=app/protos app/protos/*.proto


.PHONY: run console test setup asdf-setup migrate compile-proto
