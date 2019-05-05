class RemoveIsAnswerFromOptions < ActiveRecord::Migration[5.2]
  def change
  	remove_column :options, :is_answer
  end
end
