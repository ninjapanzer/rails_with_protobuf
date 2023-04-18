# frozen_string_literal: true

class Inhabitant < ApplicationRecord
	INHABITANT_DIETS = [
		INHABITANT_DIET_CARNIVORE = Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_CARNIVORE).to_s,
		INHABITANT_DIET_HERBIVORE = Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_HERBAVORE).to_s,
	].freeze

	INHABITANT_GROUPS = [
		INHABITANT_GROUP_DINOSAUR = 'dinosaur',
	].freeze

	attribute :group, default: INHABITANT_GROUP_DINOSAUR
	belongs_to :cage
  validates :name, presence: true
  validates :species, presence: true
  validates :diet, presence: true, inclusion: { in: INHABITANT_DIETS }
  validates :group, presence: true, inclusion: { in: INHABITANT_GROUPS }

  scope :dinosaur, -> { where(group: INHABITANT_GROUP_DINOSAUR) }
end
