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
	asdf plugin add golang || true
	asdf install ruby
	asdf install protoc
	asdf install golang

init: asdf-setup deps setup
	@bundle exec rails db:schema:load
	@GOBIN="$(pwd)/bin" go install github.com/coinbase/protoc-gen-rbi@latest

deps:
	bundle config set --local path 'vendor/bundle'protoc-gen-rbi
	bundle install

setup: init compile-proto compile-rbi migrate

migrate:
	@bundle exec rails db:migrate

compile-proto:
	@protoc --ruby_out=app/contracts/protos --proto_path=protos protos/*.proto

compile-rbi:
	@tree -dfi --noreport app/contracts/protos/ | xargs -I{} mkdir -p "sorbet/rbi/shims/{}"
	@protoc --ruby_out=app/contracts/protos --plugin=protoc-gen-rbi=./bin/protoc-gen-rbi --rbi_out=grpc=false:sorbet/rbi/shims/app/contracts/protos --proto_path=protos protos/*.proto

.PHONY: init deps run console test setup asdf-setup migrate compile-proto compile-rbi
