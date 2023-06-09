# typed: strict

# DO NOT EDIT MANUALLY
# This file was pulled from a central RBI files repository.
# Please run `bin/tapioca annotations` to update it.

class ActionMailer::Base
  sig { params(headers: T.untyped, block: T.nilable(T.proc.void)).returns(Spoom::Cli::Main::Message) }
  def mail(headers = nil, &block); end
end
