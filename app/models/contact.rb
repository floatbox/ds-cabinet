class Contact < ActiveRecord::Base
  establish_connection :siebel
  self.connection.enable_query_cache!
  self.table_name = 'SIEBEL.S_CONTACT'
  self.primary_key = 'row_id'

  SELECT_FIELDS = %w(ROW_ID INTEGRATION_ID X_SBT_WORK_PH_NUM).map{|f| "SIEBEL.S_CONTACT.#{f}"}
  default_scope ->{ select(SELECT_FIELDS).where("EMP_FLG = 'N'") }
 
  def id
    self.row_id
  end

  def phone
    x_sbt_work_ph_num
  end
  
end
