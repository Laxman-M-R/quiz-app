class AddIsAnswerToOptions < ActiveRecord::Migration[5.2]
  def change
  	add_column :options, :is_answer, :boolean, default: false
  end
end
