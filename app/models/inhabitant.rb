# frozen_string_literal: true

class Inhabitant < ApplicationRecord
	before_validation :infer_diet
	INHABITANT_DIETS = Protos::Dinosaur::Diet.descriptor.map { |diet| diet.to_s }.freeze

	# Tyrannosaurus, Velociraptor, Spinosaurus and Megalosaurus
	# Brachiosaurus, Stegosaurus, Ankylosaurus and Triceratops
	INHABITANT_SPECIES = Protos::Dinosaur::Species.descriptor.map { |species| species.to_s }.freeze

	INHABITANT_HERBAVORES = [
		Protos::Dinosaur::Species::SPECIES_BRACHIOSAURUS,
		Protos::Dinosaur::Species::SPECIES_STEGOSAURUS,
		Protos::Dinosaur::Species::SPECIES_ANKYLOSAURUS,
		Protos::Dinosaur::Species::SPECIES_TRICERATOPS,
	].map { |herba| Protos::Dinosaur::Species.lookup(herba).to_s }

	INHABITANT_CARNIVORES = [
		Protos::Dinosaur::Species::SPECIES_TYRANNOSAURUS,
		Protos::Dinosaur::Species::SPECIES_VELOCIRAPTOR,
		Protos::Dinosaur::Species::SPECIES_SPINOSAURUS,
		Protos::Dinosaur::Species::SPECIES_MEGALOSAURUS,
	].map { |carna| Protos::Dinosaur::Species.lookup(carna).to_s }

	INHABITANT_GROUPS = [
		INHABITANT_GROUP_DINOSAUR = 'dinosaur',
	].freeze

	attribute :group, default: INHABITANT_GROUP_DINOSAUR
  validates :name, presence: true
  validates :species, presence: true, inclusion: { in: INHABITANT_SPECIES }
  validates :diet, presence: true, inclusion: { in: INHABITANT_DIETS }
  validates :group, presence: true, inclusion: { in: INHABITANT_GROUPS }

  scope :dinosaur,  -> { where(group: INHABITANT_GROUP_DINOSAUR) }
  scope :herbavore,  -> { dinosaur.where(species: INHABITANT_HERBAVORES) }
  scope :carnivore, -> { dinosaur.where(species: INHABITANT_CARNIVORES) }

  def herbavore?
  	self.diet = Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_HERBAVORE)
  end

  def carnivore?
  	self.diet = Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_CARNIVORE)
  end


  private

  # set default if species is set and if its within a herbavore
  def infer_diet
  	return unless species
  	if INHABITANT_HERBAVORES.include? species
  		self.diet = Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_HERBAVORE)
  	elsif INHABITANT_CARNIVORES.include? species
  		self.diet = Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_CARNIVORE)
  	else
  		return
  	end
  end

end
