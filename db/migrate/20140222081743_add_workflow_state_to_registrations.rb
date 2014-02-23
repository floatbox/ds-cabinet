class AddWorkflowStateToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :workflow_state, :string
  end
end
