require 'rails_helper'

RSpec.describe Ward, type: :model do
  before do
    @ward = Ward.new(
      name: "Meguro",
      summary: "A ward",
      one_ldk_avg_rent: 120000,
      two_ldk_avg_rent: 160000,
      three_ldk_avg_rent: 250000,
      safety: 0.8,
      population: 1000000,
      pet_percentage: 0.2
    )
  end

  describe "name" do
    #Name tests
    it "cannot be blank" do
      @ward.name = ""
      expect(@ward).not_to be_valid
    end

    it "cannot be empty" do
      @ward.name = nil
      expect(@ward).not_to be_valid
    end

    it "has to be a string" do
      @ward.name = nil
      expect(@ward).not_to be_valid
      @ward.name = "Shinagawa"
      expect(@ward).to be_valid
    end

    it "has to be unique" do
      @ward.save
      @ward_copy = Ward.new(
        name: "Meguro",
        summary: "A ward",
        one_ldk_avg_rent: 120000,
        two_ldk_avg_rent: 160000,
        three_ldk_avg_rent: 250000,
        safety: 0.8,
        population: 1000000,
        pet_percentage: 0.2
      )
      expect(@ward_copy).not_to be_valid
    end

    it "cannot contain spaces, numbers, special characters" do
      @ward.name = "Shinagawa1"
      expect(@ward.name).not_to match(/\A[a-zA-Z]+\z/)
    end
    it "cannot be less than two in length" do
      @ward.name = "L"
      expect(@ward).not_to be_valid
      @ward.name = "La"
      expect(@ward).to be_valid
    end
    it "cannot be greater than ten in length" do
      @ward.name = "LAAAAAAAAAAAAAAAA"
      expect(@ward).not_to be_valid
      @ward.name = "Laaaaaaaaa"
      expect(@ward).to be_valid
    end
    #End of name tests
  end

  describe "summary" do
    it "cannot be blank" do
      @ward.summary = ""
      expect(@ward).not_to be_valid
      @ward.summary = "BlagBlahBlah"
      expect(@ward).to be_valid
    end

    it "cannot be empty" do
      @ward.summary = ""
      expect(@ward).not_to be_valid
      @ward.summary = "blah"
      expect(@ward).to be_valid
    end

    it "has to be a string" do
      @ward.summary = nil
      expect(@ward).not_to be_valid
      @ward.summary = "Summary of the world we are in !#$%&'()0"
      expect(@ward).to be_valid
    end

    it "cannot be more than 500 characters" do
      long_summary = "A" * 501
      ok_summary = "A" * 500
      @ward.summary = long_summary
      expect(@ward).not_to be_valid
      @ward.summary = ok_summary
      expect(@ward).to be_valid
    end
  end

  describe "1ldk_avg_rent" do
    it "cannot be less than or equal to 0" do
      @ward.one_ldk_avg_rent = 0
      expect(@ward).not_to be_valid
      @ward.one_ldk_avg_rent = 1
      expect(@ward).to be_valid
    end
    it "has to be an integer" do
      @ward.one_ldk_avg_rent = nil
      expect(@ward).not_to be_valid

      @ward.one_ldk_avg_rent = 1
      expect(@ward).to be_valid
      expect(@ward.one_ldk_avg_rent).to be_a_kind_of(Integer)
    end
  end

  describe "2ldk_avg_rent" do
    it "cannot be less than or equal to 0" do
      @ward.two_ldk_avg_rent = 0
      expect(@ward).not_to be_valid
      @ward.two_ldk_avg_rent = 1
      expect(@ward).to be_valid
    end
    it "has to be an integer" do
      @ward.two_ldk_avg_rent = nil
      expect(@ward).not_to be_valid

      @ward.two_ldk_avg_rent = 1
      expect(@ward).to be_valid
      expect(@ward.two_ldk_avg_rent).to be_a_kind_of(Integer)
    end
  end

  describe "3ldk_avg_rent" do
    it "cannot be less than or equal to 0" do
      @ward.three_ldk_avg_rent = 0
      expect(@ward).not_to be_valid
      @ward.three_ldk_avg_rent = 1
      expect(@ward).to be_valid
    end
    it "has to be an integer" do
      @ward.three_ldk_avg_rent = nil
      expect(@ward).not_to be_valid

      @ward.three_ldk_avg_rent = 1
      expect(@ward).to be_valid
      expect(@ward.three_ldk_avg_rent).to be_a_kind_of(Integer)
    end
  end

  describe "safety" do
    it "is not empty" do
      @ward.safety = nil
      expect(@ward).not_to be_valid
      @ward.safety = 0.5
      expect(@ward).to be_valid
    end
    it "has to be greater than or equal to 0" do
      @ward.safety = -1.0
      expect(@ward).not_to be_valid

      @ward.safety = 1.0
      expect(@ward).to be_valid
      expect(@ward.safety).to be >= 0.0
    end
    it "cannot be greater than 1" do
      @ward.safety = 2.0
      expect(@ward).not_to be_valid

      @ward.safety = 1.0
      expect(@ward).to be_valid
      expect(@ward.safety).to be <= 1.0
    end
    it "is a float type" do

      @ward.safety = 1.2
      expect(@ward).not_to be_valid
      @ward.safety = 1
      expect(@ward.safety).to be_between(0, 1)
    end
  end


  describe "population" do
    it "cannot be less than or equal to 0" do
      @ward.population = 0
      expect(@ward).not_to be_valid

      @ward.population = 1
      expect(@ward).to be_valid
      expect(@ward.population).to be > 0
    end
    it "has to be an integer" do
      @ward.population = nil
      expect(@ward).not_to be_valid
      @ward.population = 1
      expect(@ward).to be_valid
      expect(@ward.population).to be_an_instance_of(Integer)
    end
    it "cannot be greater than 50 million(Tokyo's entire population is estimated to cap out at 38 million)" do
      @ward.population = 51000000
      expect(@ward).not_to be_valid
      @ward.population = 50000000
      expect(@ward).to be_valid
      expect(@ward.population).to be <= 50000000
    end
  end

  describe "pet_percentage" do
    it "is not nil" do
      @ward.pet_percentage = nil
      expect(@ward).not_to be_valid

      @ward.pet_percentage = 0.5
      expect(@ward).to be_valid
    end
    it "has to be greater than or equal to 0" do
      @ward.pet_percentage = -1.0
      expect(@ward).not_to be_valid

      @ward.pet_percentage = 0.1
      expect(@ward).to be_valid
      expect(@ward.pet_percentage).to be_between(0, 1)
    end
    it "cannot be greater than 1" do
      @ward.pet_percentage = 2
      expect(@ward).not_to be_valid

      @ward.pet_percentage = 0.1
      expect(@ward).to be_valid
      expect(@ward.pet_percentage).to be_between(0, 1)
    end
    it "is a float type" do
      @ward.pet_percentage = nil
      expect(@ward).not_to be_valid
      @ward.pet_percentage = 1.0
      expect(@ward).to be_valid
      expect(@ward.pet_percentage).to be_between(0, 1)
    end
  end

end
