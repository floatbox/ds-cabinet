class Contact < ActiveRecord::Base
  establish_connection :siebel
  self.connection.enable_query_cache!
  self.table_name = 'SIEBEL.S_CONTACT'
  self.primary_key = 'row_id'

  SELECT_FIELDS = %w(ROW_ID INTEGRATION_ID X_SBT_WORK_PH_NUM FST_NAME LAST_NAME).map{|f| "SIEBEL.S_CONTACT.#{f}"}
  default_scope ->{ select(SELECT_FIELDS).where("EMP_FLG = 'N'") }
 
  def id
    self.row_id
  end

  def phone
    x_sbt_work_ph_num
  end

  def first_name
    fst_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
end
