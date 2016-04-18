class MagicField < ActiveRecord::Base
  serialize :value_options
  has_many :magic_field_relationships, :dependent => :destroy
  has_many :owners, :through => :magic_field_relationships, :as => :owner
  has_many :magic_attributes, :dependent => :destroy
  
  validates_presence_of :name, :datatype
  validates_format_of :name, :with => /\A[a-z][a-z0-9_]+\z/

  before_save :set_pretty_name

  def value_options_array
    value_options.split("\r\n") rescue []
  end

  def self.datatypes
    ["select", "multiselect", "currency", "radio_buttons", "multi_check_box", "check_box_boolean", "date", "datetime", "integer", "string"]
  end

  def type_cast(value)
    begin
      case datatype.to_sym
        when :string
          value
        when :currency
          value
        when :check_box_boolean
          (value.to_int == 1) ? true : false 
        when :date
          Date.parse(value)
        when :datetime
          Time.parse(value)
        when :integer
          value.to_int
        when :multi_check_box
          YAML.load(value) rescue []
        when :multiselect
          YAML.load(value) rescue []
      else
        if is_association
          datatype.constantize.find_by_id(value)
        else
          value
        end
      end
    rescue
      value
    end
  end
  
  # Display a nicer (possibly user-defined) name for the column or use a fancified default.
  def set_pretty_name
    self.pretty_name = name.humanize if  pretty_name.blank?
  end
  
end
