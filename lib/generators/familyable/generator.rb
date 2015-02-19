require 'rails/generators'
module Familyable
  class Generator < Rails::Generators::Base
    desc "Shared options and methods for Familyable Generators"
    
    argument :model_name, type: :string, required: true, desc: "model name"    

  private

    def model_class_name
      @model_name.camelize
    end

    def model_base_name
      @model_name.underscore.split("/").last
    end


    def relationship_class_name
      "#{model_class_name}Relationship"
    end
  end
end