class CreateAttachmentsMessages < ActiveRecord::Migration
  def change
    create_table :attachments_messages do |t|
      t.integer :attachment_id
      t.integer :message_id
    end
    add_index :attachments_messages, :attachment_id
    add_index :attachments_messages, :message_id
  end
end
