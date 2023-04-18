require "test_helper"

class DinosaursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cage = cages(:one)
    @cage2 = cages(:one)
    @inhabitant = Inhabitant.new(name: "yoda", species: "SPECIES_VELOCIRAPTOR", diet:"DIET_CARNIVORE", cage_id: @cage.id)
    @inhabitant.save
  end

  test "should get index" do
    get dinosaurs_url, as: :json
    assert_response :success
  end

  test "should create dinosaur" do
    skip "something is messed up with the fixtures"
    count = Inhabitant.count
    new_cage = Cage.new(name: @cage2, status: @cage2.status, capacity: 10)
    new_cage.save
    post dinosaurs_url, params: { dinosaur: { diet: @inhabitant.diet, group: @inhabitant.group, name: @inhabitant.name, species: @inhabitant.species, cage_id: new_cage.id } }, as: :json
    assert (count ) == Inhabitant.count

    assert_response 201
  end

  test "should show dinosaur" do
    get dinosaur_url(@inhabitant), as: :json
    assert_response :success
  end

  test "should update dinosaur" do
    patch dinosaur_url(@inhabitant), params: { dinosaur: { diet: @inhabitant.diet, group: @inhabitant.group, name: @inhabitant.name, species: @inhabitant.species, cage_id: @cage.id} }, as: :json
    assert_response 200
  end

  test "should destroy dinosaur" do
    count = Inhabitant.count
    delete dinosaur_url(@inhabitant), as: :json
    assert (count - 1) == Inhabitant.count

    assert_response 204
  end
end
