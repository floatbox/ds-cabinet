class Account < ActiveRecord::Base
  include Ds::Siebel::Model

  establish_connection :siebel
  self.connection.enable_query_cache!
  self.table_name = 'SIEBEL.S_ORG_EXT'
  self.primary_key = 'row_id'

  siebel_attr :siebel_integration_id, soap: 'IntegrationId'
  siebel_attr :siebel_type, soap: 'Type'
  siebel_attr :full_name, soap: 'SBTName', column: 'x_sbt_name'
  siebel_attr :inn, soap: 'SBTINN', column: 'x_sbt_inn'
  siebel_attr :ogrn, soap: 'SBTOGRN', column: 'x_sbt_ogrn'

  SELECT_FIELDS = %w(ROW_ID X_SBT_NAME ACCNT_TYPE_CD X_SBT_INN X_SBT_OGRN INTEGRATION_ID).map{|f| "SIEBEL.S_ORG_EXT.#{f}"}
  default_scope ->{ select(SELECT_FIELDS).where("INT_ORG_FLG = 'N'") }

  def siebel_integration_id
    @siebel_integration_id ||= integration_id || "DC#{DateTime.now.strftime('%Q')}"
  end

  def siebel_type
    'Юридическое лицо'
  end

  def id
    row_id
  end

end
