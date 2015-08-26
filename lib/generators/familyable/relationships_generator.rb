require File.join(File.dirname(__FILE__), 'generator')
module Familyable
  class RelationshipsGenerator < Familyable::Generator
    desc "Options and methods for Familyable::Relationship"
    
    argument :model_name, type: :string, required: true, desc: "model name"    
    class_option :delete, type: :boolean, required: false, default: false, desc: "delete relationship for model: defaut=false"

    def generate_relationships
      if options[:delete]
        system("bundle exec rails d model #{clean_relationship_class_name}")
      else
        generate "model", "#{clean_relationship_class_name} #{clean_model_base_name}:references child:references"
      end
    end

    def add_class_name
      unless options[:delete]
        gsub_file(relationship_model_path, "belongs_to :child", "belongs_to :child, class_name:\"#{clean_model_class_name}\"") 
      end
    end

    def generation_field
      if options[:delete]
        system("bundle exec rails generate migration RemoveGenerationFrom#{model_class_text} generation:integer")
      else
        generate "migration", "AddGenerationTo#{model_class_text} generation:integer"
      end
    end
  end
end