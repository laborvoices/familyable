module Familyable
  module Generations
  extend ActiveSupport::Concern

    after_save :update_generations
    after_destroy :update_generations
  
  private
  
    def update_generations

      child.descendents(true).all.each do |descendent_group|
        update_generation(descendent_group)
      end
    end

    def update_generation descendent_group
      descendent_group.set_generation     
      descendent_group.save
    end

  end
end