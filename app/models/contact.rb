class Contact < ActiveRecord::Base
  include Ds::Siebel::Model

  establish_connection :siebel
  self.connection.enable_query_cache!
  self.table_name = 'SIEBEL.S_CONTACT'
  self.primary_key = 'row_id'

  siebel_attr :integration_id
  siebel_attr :last_name
  siebel_attr :first_name, column: 'fst_name'
  siebel_attr :phone_work, soap: 'SBTWorkPhone', column: 'x_sbt_work_ph_num'

  after_save :reset_cache

  SELECT_FIELDS = %w(ROW_ID INTEGRATION_ID X_SBT_WORK_PH_NUM FST_NAME LAST_NAME).map{|f| "SIEBEL.S_CONTACT.#{f}"}
  default_scope ->{ select(SELECT_FIELDS).where("EMP_FLG = 'N'") }
 
  def id
    self.row_id
  end

  def phone
    x_sbt_work_ph_num
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

    def reset_cache
      self.class.connection.clear_query_cache
    end
  
end
