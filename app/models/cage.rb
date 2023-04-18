# frozen_string_literal: true

class Cage < ApplicationRecord
  has_many :inhabitants, -> { where(group: Inhabitant::INHABITANT_GROUP_DINOSAUR) }, before_add: [:herbavores_of_a_feather, :carnivoric_homogony]

  CAGE_STATUSES = Protos::Cage::Status.descriptor.map { |status| status.to_s }.freeze

  validates :status, presence: true, inclusion: { in: CAGE_STATUSES }
  validates :name, :capacity, presence: true
  validate :cannot_exceed_capacity
  validate :power_off_if_no_dinosaurs
  validate :cannot_add_or_move_inhabitant_to_off_cage

  private

  def carnivore_cage?
    inhabitants.all? { |dino| dino.diet == Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_CARNIVORE).to_s }
  end

  def herbavore_cage?
    inhabitants.all? { |dino| dino.diet == Protos::Dinosaur::Diet.lookup(Protos::Dinosaur::Diet::DIET_HERBAVORE).to_s }
  end

  def power_off_if_no_dinosaurs
    puts status
    if inhabitants.any? && status == Protos::Cage::Status.lookup(Protos::Cage::Status::STATUS_DOWN).to_s
      errors.add(:base, 'Cannot power off cage that contains dinosaurs')
    end
  end

  def population
  	inhabitants.count
	end

  def cannot_exceed_capacity
    if capacity && population > capacity
      errors.add(:inhabitants, "cannot exceed the maximum capacity of #{capacity}")
    end
  end

  def cannot_add_or_move_inhabitant_to_off_cage
    if status == Protos::Cage::Status.lookup(Protos::Cage::Status::STATUS_DOWN) && (self.inhabitants.any? || self.inhabitants.any?(previous_changes[:id]))
      errors.add(:status, "cannot add or move an inhabitant to a down cage")
    end
  end

  def herbavores_of_a_feather(inhabitant)
    if inhabitants.any? && herbavore_cage? && inhabitant.carnivore? && (inhabitants+[inhabitant]).map(&:diet).uniq.count > 1
      raise ActiveRecord::Rollback, 'cannot be of different diets'
    end
  end

  def carnivoric_homogony(inhabitant)
    if inhabitants.any? && carnivore_cage? && inhabitant.herbavore? && (inhabitants+[inhabitant]).map(&:species).uniq.count > 1
      raise ActiveRecord::Rollback, 'cannot be of different species'
    end
  end
end
