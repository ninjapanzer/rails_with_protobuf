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

init: asdf-setup deps protoc-deps
	@bundle exec rails db:schema:load

protoc-deps:
	@GOBIN="$(shell pwd)/bin" go install github.com/coinbase/protoc-gen-rbi@latest
	@GOBIN="$(shell pwd)/bin" go install github.com/zchee/protoc-gen-openapi@latest

deps:
	bundle config set --local path 'vendor/bundle'
	bundle install

setup: init compile-proto compile-rbi migrate

migrate:
	@bundle exec rails db:migrate

compile-proto:
	@protoc --ruby_out=app/contracts/protos --proto_path=protos protos/*.proto

compile-rbi:
	@find app/contracts/protos/ -type d -exec sh -c 'mkdir -p "sorbet/rbi/shims/${1#app/contracts/protos/}"' sh {} \;
	@protoc --ruby_out=app/contracts/protos --plugin=protoc-gen-rbi=$(shell pwd)/bin/protoc-gen-rbi --rbi_out=grpc=false:sorbet/rbi/shims/app/contracts/protos --proto_path=protos protos/*.proto

compile-oas:
	@protoc --plugin=protoc-gen-openapi=$(shell pwd)/bin/protoc-gen-openapi --openapi_out=docs --proto_path=protos protos/*.proto

.PHONY: init deps protoc-deps run console test setup asdf-setup migrate compile-proto compile-rbi compile-oas
