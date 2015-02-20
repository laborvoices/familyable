require 'rails/generators'
module Familyable
  class Generator < Rails::Generators::Base
    desc "Shared options and methods for Familyable Generators"
    
    argument :model_name, type: :string, required: true, desc: "model name"    

  private

    def model_class_name
      @model_name.camelize
    end

    def clean_model_class_name
      model_class_name.split("::").last
    end

    def engine_name
      parts = model_class_name.split("::")
      if parts.length > 1
        parts.pop()
        parts.join("::")
      end
    end

    def model_base_name
      @model_name.underscore
    end

    def clean_model_base_name
      model_base_name.split("/").last
    end

    def relationship_class_name
      "#{model_class_name}Relationship"
    end

    def clean_relationship_class_name
      "#{clean_model_class_name}Relationship"
    end

    def app_root_path
      if engine_name.nil?
        "#{Rails.root}"
      else
        "#{engine_name.constantize::Engine.root}"
      end
    end

    def relationship_model_path
      "#{app_root_path}/app/models/#{relationship_class_name.underscore}.rb"
    end
  end
end