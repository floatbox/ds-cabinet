class Registration < ActiveRecord::Base
  validates_presence_of :phone, :ogrn
  validates_format_of :phone, with: /\A(\+[0-9]{11})\Z/i
  validates_format_of :ogrn, with: /\A([0-9]{13})\Z/i
  validate :company_exists, if: :new_record?

  def company
    @company ||= Ds::Spark::Company.where(ogrn: ogrn).first
  rescue
    nil
  end

  def user
    @user = { phone: phone }
  end

  def inn
    company.try(:inn)
  end

  def name
    company.try(:name)
  end

  def region
    company.try(:region_code)
  end

  def as_json(options = {})
    super((options || {}).merge({
      methods: [:inn, :name, :region]
    }))
  end

  private

    def company_exists
      errors.add(:company, :does_not_exist) unless company
    end
end
