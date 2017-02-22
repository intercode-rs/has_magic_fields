# Always work through the interface MagicAttribute.value
class MagicAttribute < ActiveRecord::Base
  belongs_to :magic_field

  #def self.ransackable_attributes(auth_object = nil)
  #  [:value]
  #end

  def to_s
    value
  end
  
end
