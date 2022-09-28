class AddPostSubmissionStipulationToStipulation < ActiveRecord::Migration[5.1]
  def change
    add_column :stipulations, :post_submission_stipulation, :boolean, default: false
  end
end
