class AddWidgetAttributesToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :widget_type, :string
    add_column :topics, :widget_options, :text
  end
end
