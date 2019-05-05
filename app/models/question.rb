class Question < ApplicationRecord
  belongs_to :user
  has_many :options, dependent: :delete_all, :autosave => true
  serialize :options
  validates_length_of :options, maximum: 4

  accepts_nested_attributes_for :options
end
