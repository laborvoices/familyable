module Familyable
  module Generations
  extend ActiveSupport::Concern

    included do
      after_save :update_generations
      after_destroy :update_generations
    end

  private
  
    def update_generations
      child.descendents(true).all.each do |descendent_group|
        descendent_group.update_generation
      end
    end
  end
end