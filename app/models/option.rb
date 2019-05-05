class Option < ApplicationRecord
  belongs_to :question
  validates_associated :question
end
