require File.join(File.dirname(__FILE__), 'generator')
module Familyable
  class RelationshipGenerator < Familyable::Generator
    desc "Options and methods for Familyable::Relationship"
    
    argument :model_name, type: :string, required: true, desc: "model name"    
    class_option :delete, type: :boolean, required: false, default: false, desc: "delete relationship for model: defaut=false"


    def generate_relationships
      if options[:delete]
        system("bundle exec rails d model #{relationship_class_name}")
      else
        generate "model", "#{relationship_class_name} #{model_base_name}:references child:references"
      end
    end

  end
end