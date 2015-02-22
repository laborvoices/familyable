module Familyable
  module Relationships
  extend ActiveSupport::Concern



    included do
      has_many relationships_name.to_sym
      has_many :children, through: relationships_name.to_sym
      has_one inv_relationships_name.to_sym, class_name: relationship_class_name, foreign_key: "child_id"
      has_one :parent, through: inv_relationships_name.to_sym, source: model_name.to_sym   
    end
    
    # *****************************
    #
    # Main Interface
    #
    # *****************************

    module ClassMethods
      def masters
        where(without_parents_where_sql)
      end
    end

    def master
      call = elders
      call.where(klass.without_parents_where_sql).first
    end

    def descendents include_self=false
      query_call(
        "#{table_name}.id IN (#{descendents_sql_list})",
        include_self
      )
    end
    
    def elders include_self=false
      query_call(
        "#{table_name}.id IN (#{elders_sql_list})",
        include_self
      )
    end

    def siblings include_self=false
      query_call(
        "#{table_name}.id IN (#{siblings_sql_list})",
        include_self
      )      
    end

    def family include_self=false
      query_call(
        "#{table_name}.id IN (#{family_sql_list})",
        include_self
      )
    end

    # *****************************
    #
    # Utilities
    #
    # *****************************

    module ClassMethods

      #
      # ID LISTS
      #

      def children_of(id_sql)
        id_sql = safe_identifier(id_sql)
        tree_sql =  <<-SQL
          SELECT DISTINCT #{relationship_table_name}.child_id 
          FROM #{table_name}
          JOIN #{relationship_table_name} 
          ON #{table_name}.id = #{relationship_table_name}.#{parent_field_name}
          WHERE #{table_name}.id = #{id_sql}
        SQL
      end

      def descendents_of(id_sql)
        id_sql = safe_identifier(id_sql)
        tree_sql =  <<-SQL
          WITH RECURSIVE search_tree(id, path) AS (
              SELECT id, ARRAY[id]
              FROM #{table_name}
              WHERE id = #{id_sql}
            UNION ALL
              SELECT #{table_name}.id, path || #{table_name}.id
              FROM search_tree
              JOIN #{relationship_table_name} ON #{relationship_table_name}.#{parent_field_name} = search_tree.id
              JOIN #{table_name} ON #{table_name}.id = #{relationship_table_name}.child_id
              WHERE NOT #{table_name}.id = ANY(path)
          )
          SELECT id FROM search_tree ORDER BY path
        SQL
      end

      def elders_of(id_sql)
        id_sql = safe_identifier(id_sql)
        tree_sql =  <<-SQL
          WITH RECURSIVE search_tree(id, path) AS (
              SELECT id, ARRAY[id]
              FROM #{table_name}
              WHERE id = #{id_sql}
            UNION ALL
              SELECT #{table_name}.id, path || #{table_name}.id
              FROM search_tree
              JOIN #{relationship_table_name} ON #{relationship_table_name}.child_id = search_tree.id
              JOIN #{table_name} ON #{table_name}.id = #{relationship_table_name}.#{parent_field_name}
              WHERE NOT #{table_name}.id = ANY(path)
          )
          SELECT id FROM search_tree ORDER BY path
        SQL
      end

      def without_parents_where_sql
        "#{table_name}.id NOT IN (
          SELECT DISTINCT #{relationship_table_name}.child_id
          FROM #{relationship_table_name}
        )"
      end

      #
      # UTILS
      #

      def relationship_table_name
        if @relationship_table_name.nil?
           @relationship_table_name = "#{table_name.singularize}_relationships"
        end
        @relationship_table_name
      end

      def relationship_class_name
       if @relationship_class_name.nil?
           @relationship_class_name = "#{self.name.demodulize}Relationship"
        end
        @relationship_class_name
      end

      def model_name
       if @model_name.nil?
           @model_name = "#{self.name.demodulize.downcase}"
        end
        @model_name
      end

      def relationships_name
       if @relationships_name.nil?
           @relationships_name = "#{self.name.demodulize.downcase}_relationships"
        end
        @relationships_name
      end

      def inv_relationships_name
       if @inv_relationships_name.nil?
           @inv_relationships_name = "inverse_#{relationships_name}"
        end
        @inv_relationships_name
      end

      def parent_field_name
        if @parent_field_name.nil?
           @parent_field_name = "#{self.name.demodulize.downcase}_id"
        end
        @parent_field_name
      end

      def safe_identifier id_sql
        if id_sql.to_i == 0
          "(#{id_sql})"
        else
          id_sql
        end
      end
    end


  private

    #
    #  SQL LISTS
    #
  
    def descendents_sql_list
      klass.descendents_of(id)
    end

    def elders_sql_list
      klass.elders_of(id)
    end

    def siblings_sql_list
      klass.children_of(select_parent_sql)
    end

    def family_sql_list
      klass.descendents_of(select_master_sql)
    end

    #
    #  SQL
    #

    def select_parent_sql
      "SELECT #{relationship_table_name}.#{parent_field_name} 
      FROM #{klass.table_name}
      JOIN #{relationship_table_name}
      ON #{klass.table_name}.id = #{relationship_table_name}.#{parent_field_name}
      WHERE #{relationship_table_name}.child_id = #{id}
      LIMIT 1"
    end


    def select_master_sql
      select_from_sql_list_and(klass.elders_of(id),klass.without_parents_where_sql)
    end

    #
    # Utils
    #

    def query_call(where_sql,include_self=false)
      call = self.class.where(where_sql)
      call = call.where.not(id: id) unless include_self
      call    
    end

    def klass
      @klass ||= self.class
    end

    def table_name
      @table_name ||= klass.table_name
    end

    def relationship_table_name
      @relationship_table_name ||= klass.relationship_table_name
    end

    def parent_field_name
      @parent_field_name ||= klass.parent_field_name
    end

    def select_from_sql_list_and(sql_list,and_sql)
      "SELECT #{klass.table_name}.id FROM #{klass.table_name} 
      WHERE (
        #{klass.table_name}.id IN ( 
          #{sql_list}
        )
      ) AND (
        #{and_sql}
      )"
    end
  end
end
