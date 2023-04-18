class CageSerializer

	def initialize(cage_object, target = nil)
		@cage = cage_object
		@serialzier = case target
		when :with_dinosaurs
			method(:serialize_cage_with_dinosaur)
		else
			method(:serialize_cage)
		end
	end

	def serialize
		@serialzier.call
	end

	def serialize_cage
		Protos::Cage::Cage.new(
			name: @cage.name,
			status: @cage.status,
			capacity: @cage.capacity,
		)
	end

	def serialize_cage_with_dinosaur
		Protos::Cage::CageInhabitants.new(
			name: @cage.name,
			status: @cage.status,
			inhabitants: @cage.inhabitants.map { |dino| DinosaurSerializer.new(dino).serialize }
		)
	end

end
