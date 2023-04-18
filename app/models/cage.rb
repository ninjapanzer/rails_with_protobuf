# frozen_string_literal: true

class Cage < ApplicationRecord
  has_many :inhabitants, -> { where(group: Inhabitant::INHABITANT_GROUP_DINOSAUR) }

  CAGE_STATUSES = [
		CAGE_STATUS_ACTIVE = Protos::Status.lookup(Protos::Status::STATUS_ACTIVE).to_s,
		CAGE_STATUS_DOWN = Protos::Status.lookup(Protos::Status::STATUS_DOWN).to_s,
  ].freeze

  validates :status, presence: true, inclusion: { in: CAGE_STATUSES }
  validates :name, :capacity, presence: true
  validate :cannot_exceed_capacity
  validate :power_off_if_no_dinosaurs
  validate :cannot_add_or_move_inhabitant_to_off_cage

  private

  def power_off_if_no_dinosaurs
    if inhabitants.any?
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
    if status == CAGE_STATUS_DOWN && (self.inhabitants.any? || self.inhabitants.any?(previous_changes[:id]))
      errors.add(:status, "cannot add or move an inhabitant to a down cage")
    end
  end
end
