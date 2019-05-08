class Question < ApplicationRecord
  belongs_to :user
  has_many :options, dependent: :delete_all, :autosave => true
  accepts_nested_attributes_for :options
end
