class Spree::AssembliesPart < ActiveRecord::Base
  #set_primary_keys :assembly_id, :part_id
  belongs_to :assembly, :class_name => "Spree::Product", :foreign_key => "assembly_id"
  belongs_to :part, :class_name => "Spree::Variant", :foreign_key => "part_id"

  #validate :no_circular_dependencies - Needs to be handled in product decorator
  #
  #def no_circular_dependencies
  #  errors.add_to_base('This would create a circular dependency.') if has_circular_dependencies(self)
  #end
  #
  #def has_circular_dependencies?(assembly)
  #  if assembly == part
  #    return false
  #  elsif part.assembly?
  #    return part.has_circular_dependencies?(assembly)
  #  else
  #    return true
  #  end
  #end

  def self.get(assembly_id, part_id)
    Spree::AssembliesPart.find_by_assembly_id_and_part_id(assembly_id, part_id)
  end

  def save
    Spree::AssembliesPart.update_all("count = #{count}", 
        ["assembly_id = ? AND part_id = ?", assembly_id, part_id])
  end

  def destroy
    Spree::AssembliesPart.delete_all(["assembly_id = ? AND part_id = ?", assembly_id, part_id])
  end
end
