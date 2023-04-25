# Code generated by protoc-gen-rbi. DO NOT EDIT.
# source: cage.proto
# typed: strict

class Protos::Cage::Cage
  include ::Google::Protobuf
  include ::Google::Protobuf::MessageExts
  extend ::Google::Protobuf::MessageExts::ClassMethods

  sig { params(str: String).returns(Protos::Cage::Cage) }
  def self.decode(str)
  end

  sig { params(msg: Protos::Cage::Cage).returns(String) }
  def self.encode(msg)
  end

  sig { params(str: String, kw: T.untyped).returns(Protos::Cage::Cage) }
  def self.decode_json(str, **kw)
  end

  sig { params(msg: Protos::Cage::Cage, kw: T.untyped).returns(String) }
  def self.encode_json(msg, **kw)
  end

  sig { returns(::Google::Protobuf::Descriptor) }
  def self.descriptor
  end

  sig do
    params(
      name: T.nilable(String),
      status: T.nilable(T.any(Symbol, String, Integer)),
      population: T.nilable(Integer),
      capacity: T.nilable(Integer)
    ).void
  end
  def initialize(
    name: "",
    status: :STATUS_UNKNOWN,
    population: 0,
    capacity: 0
  )
  end

  sig { returns(String) }
  def name
  end

  sig { params(value: String).void }
  def name=(value)
  end

  sig { void }
  def clear_name
  end

  sig { returns(Symbol) }
  def status
  end

  sig { params(value: T.any(Symbol, String, Integer)).void }
  def status=(value)
  end

  sig { void }
  def clear_status
  end

  sig { returns(Integer) }
  def population
  end

  sig { params(value: Integer).void }
  def population=(value)
  end

  sig { void }
  def clear_population
  end

  sig { returns(Integer) }
  def capacity
  end

  sig { params(value: Integer).void }
  def capacity=(value)
  end

  sig { void }
  def clear_capacity
  end

  sig { params(field: String).returns(T.untyped) }
  def [](field)
  end

  sig { params(field: String, value: T.untyped).void }
  def []=(field, value)
  end

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def to_h
  end
end

class Protos::Cage::CageInhabitants
  include ::Google::Protobuf
  include ::Google::Protobuf::MessageExts
  extend ::Google::Protobuf::MessageExts::ClassMethods

  sig { params(str: String).returns(Protos::Cage::CageInhabitants) }
  def self.decode(str)
  end

  sig { params(msg: Protos::Cage::CageInhabitants).returns(String) }
  def self.encode(msg)
  end

  sig { params(str: String, kw: T.untyped).returns(Protos::Cage::CageInhabitants) }
  def self.decode_json(str, **kw)
  end

  sig { params(msg: Protos::Cage::CageInhabitants, kw: T.untyped).returns(String) }
  def self.encode_json(msg, **kw)
  end

  sig { returns(::Google::Protobuf::Descriptor) }
  def self.descriptor
  end

  sig do
    params(
      name: T.nilable(String),
      status: T.nilable(T.any(Symbol, String, Integer)),
      inhabitants: T.nilable(T::Array[T.nilable(Protos::Dinosaur::Dinosaur)])
    ).void
  end
  def initialize(
    name: "",
    status: :STATUS_UNKNOWN,
    inhabitants: []
  )
  end

  sig { returns(String) }
  def name
  end

  sig { params(value: String).void }
  def name=(value)
  end

  sig { void }
  def clear_name
  end

  sig { returns(Symbol) }
  def status
  end

  sig { params(value: T.any(Symbol, String, Integer)).void }
  def status=(value)
  end

  sig { void }
  def clear_status
  end

  sig { returns(T::Array[T.nilable(Protos::Dinosaur::Dinosaur)]) }
  def inhabitants
  end

  sig { params(value: ::Google::Protobuf::RepeatedField).void }
  def inhabitants=(value)
  end

  sig { void }
  def clear_inhabitants
  end

  sig { params(field: String).returns(T.untyped) }
  def [](field)
  end

  sig { params(field: String, value: T.untyped).void }
  def []=(field, value)
  end

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def to_h
  end
end

module Protos::Cage::Status
  self::STATUS_UNKNOWN = T.let(0, Integer)
  self::STATUS_ACTIVE = T.let(1, Integer)
  self::STATUS_DOWN = T.let(2, Integer)

  sig { params(value: Integer).returns(T.nilable(Symbol)) }
  def self.lookup(value)
  end

  sig { params(value: Symbol).returns(T.nilable(Integer)) }
  def self.resolve(value)
  end

  sig { returns(::Google::Protobuf::EnumDescriptor) }
  def self.descriptor
  end
end