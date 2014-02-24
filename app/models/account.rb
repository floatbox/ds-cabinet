class Account < ActiveRecord::Base
  include Ds::Siebel::Model

  attr_accessor :full_name, :inn, :ogrn

  siebel_attr :siebel_integration_id, soap: 'IntegrationId'
  siebel_attr :siebel_type, soap: 'Type'
  siebel_attr :status, soap: 'AccountStatus'
  siebel_attr :full_name, soap: 'SBTName'
  siebel_attr :inn, soap: 'SBTINN'
  siebel_attr :ogrn, soap: 'SBTOGRN'

  def siebel_integration_id
    @siebel_integration_id ||= "DC#{DateTime.now.strftime('%Q')}"
  end

  def siebel_type
    'Юридическое лицо'
  end

  def status
    'Зарегистрирован'
  end
end