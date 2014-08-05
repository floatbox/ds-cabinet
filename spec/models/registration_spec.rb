require 'spec_helper'
require 'savon_helper'

describe Registration do
  # Registration: [
  #   "phone", 
  #   "ogrn", 
  #   "inn", 
  #   "company_name", 
  #   "region_code",
  #   "workflow_state", 
  #   "admin_notified", 
  #   "created_at", "updated_at"
  # ]
  #
  before { 
    Ds::Spark.api.send(:cookies=, [HTTPI::Cookie.new('fake')])
  }

  SAMPLE_1_INN    = '0123456789'
  SAMPLE_2_INN    = '7714698320'
  SAMPLE_3_INN    = '532204481098'

  SAMPLE_1_PHONE  = '+7(495)111-1111'
  SAMPLE_2_PHONE  = '+7(495)111-1112'
  SAMPLE_1_OGRN   = '0123456789012'
  SAMPLE_2_OGRN   = '5077746887312'
  SAMPLE_3_OGRNIP = '311533223600062'

  describe '.new' do
    context 'non-existent OGRN' do
      let(:registration_params) { ActionController::Parameters.new( :registration => {
        ogrn: SAMPLE_1_OGRN, 
        phone: SAMPLE_1_PHONE
      }).require(:registration).permit(:phone, :ogrn) }

      it 'should not set SPARK_ATTRIBUTES and not save' do
        @registration = Registration.new(registration_params)
        Registration::SPARK_ATTRIBUTES.each_key do |attr|
          @registration[attr].should be_nil
        end
        @registration.ogrn.should eql SAMPLE_1_OGRN
        @registration.phone.should eql Phone.new(SAMPLE_1_PHONE).value

        @registration.save.should be false
        binding.pry
        @registration.errors.messages.should eql({:company=>["компания с таким ОГРН не существует"]})
      end
    end

    context 'existent OGRN' do
      let(:registration_params) { ActionController::Parameters.new( :registration => {
        ogrn: SAMPLE_2_OGRN, 
        phone: SAMPLE_2_PHONE
      }).require(:registration).permit(:phone, :ogrn) }

      it 'should set SPARK_ATTRIBUTES and save' do
        @registration = Registration.new(registration_params)
        @registration.inn.should eql  "7714698320"
        @registration.name.should eql "Ликвидационная комиссия ООО \"Пример\" (промежуточный ликвидационный баланс)"
        @registration.region_code.should eql "45"

        @registration.ogrn.should eql SAMPLE_2_OGRN
        @registration.phone.should eql Phone.new(SAMPLE_2_PHONE).value

        @registration.save.should be true
        @registration.errors.messages.should be_empty
      end
    end
  end

=begin
  shared_examples_for :sample_company_1 do
    it 'has proper options' do
      company.spark_id.should == '1239121'
      company.inn.should == SAMPLE_1_INN
      company.name.should == 'Открытое акционерное общество "Уфимский витаминный завод" -"УфаВИТА".'
      company.region_code.should == '79'
    end
  end

  shared_examples_for :sample_company_2 do
    it 'has proper options' do
      company.spark_id.should == '7687773' # could change after a while
                                           # it was '5809801' formerly
      company.inn.should == SAMPLE_2_INN
      company.ogrn.should == SAMPLE_2_OGRN
      company.name.should == 'Ликвидационная комиссия ООО "Пример" (промежуточный ликвидационный баланс)'
      company.region_code.should == '45'
    end
  end

  shared_examples_for :sample_company_3 do
    it 'has proper options' do
      company.spark_id.should == '37766739'
      company.inn.should == SAMPLE_3_INN
      company.ogrnip.should == SAMPLE_3_OGRNIP
      company.name.should == 'Иванова Светлана Владимировна'
      company.region_code.should == '49'
    end
  end

  describe '.where' do
    context 'by inn' do
      let(:companies) { Ds::Spark::Company.where(inn: SAMPLE_1_INN) }
      let(:company) { companies.first }
      it { companies.count.should == 1 }
      it_behaves_like :sample_company_1
    end

    context 'by ogrn' do
      let(:companies) { Ds::Spark::Company.where(ogrn: SAMPLE_2_OGRN) }
      let(:company) { companies.first }
      it { companies.count.should == 1 }
      it_behaves_like :sample_company_2
    end

    context 'by ogrnip' do
      let(:companies) { Ds::Spark::Company.where(ogrnip: SAMPLE_3_OGRNIP) }
      let(:company) { companies.first }
      it { companies.count.should == 1 }
      it_behaves_like :sample_company_3
    end

    context 'by inn and ogrn' do
      context 'company exists' do
        let(:companies) { Ds::Spark::Company.where(inn: SAMPLE_2_INN, ogrn: SAMPLE_2_OGRN) }
        let(:company) { companies.first }
        it { companies.count.should == 1 }
        it_behaves_like :sample_company_2
      end

      context 'company does not exist' do
        let(:companies) { Ds::Spark::Company.where(inn: SAMPLE_1_INN, ogrn: SAMPLE_2_OGRN) }
        it { companies.count.should == 0 }
      end
    end

    context 'by name' do
      context 'name and region code are specified' do
        let(:companies) { Ds::Spark::Company.where(name: 'ООО "Пример"', region_code: 45) }
        let(:company) { companies[1] }
        it { companies.count.should == 5 }
        it_behaves_like :sample_company_2
      end

      context 'region code missing' do
        it { expect { Ds::Spark::Company.where(name: 'ООО "Пример"') }.to raise_error(Ds::Spark::ParametersMissing) }
      end
    end
  end

  describe 'aliases' do
    let(:company) { Ds::Spark::Company.new }

    describe '.find_by_inn' do
      it 'calls .where method' do
        expect(Ds::Spark::Company).to receive(:where).with({inn: SAMPLE_1_INN}) { [company] }
        Ds::Spark::Company.find_by_inn(SAMPLE_1_INN).should == company
      end

      it 'raises error if empty array returned' do
        expect(Ds::Spark::Company).to receive(:where) { [] }
        expect { Ds::Spark::Company.find_by_inn(SAMPLE_1_INN) }.to raise_error(Ds::Spark::RecordNotFound)
      end
    end

    describe '.find_by_ogrn' do
      it 'calls .where method' do
        expect(Ds::Spark::Company).to receive(:where).with({ogrn: SAMPLE_2_OGRN}) { [company] }
        Ds::Spark::Company.find_by_ogrn(SAMPLE_2_OGRN).should == company
      end

      it 'raises error if empty array returned' do
        expect(Ds::Spark::Company).to receive(:where) { [] }
        expect { Ds::Spark::Company.find_by_ogrn(SAMPLE_2_OGRN) }.to raise_error(Ds::Spark::RecordNotFound)
      end
    end

    describe '.find_by_ogrnip' do
      it 'calls .where method' do
        expect(Ds::Spark::Company).to receive(:where).with({ogrnip: SAMPLE_3_OGRNIP}) { [company] }
        Ds::Spark::Company.find_by_ogrnip(SAMPLE_3_OGRNIP).should == company
      end

      it 'raises error if empty array returned' do
        expect(Ds::Spark::Company).to receive(:where) { [] }
        expect { Ds::Spark::Company.find_by_ogrnip(SAMPLE_3_OGRNIP) }.to raise_error(Ds::Spark::RecordNotFound)
      end
    end

    describe '.find_by_ogrn_or_ogrnip' do
      context 'ogrn' do
        let(:company) { Ds::Spark::Company.find_by_ogrn_or_ogrnip(SAMPLE_2_OGRN) }
        it_behaves_like :sample_company_2
      end

      context 'ogrnip' do
        let(:company) { Ds::Spark::Company.find_by_ogrn_or_ogrnip(SAMPLE_3_OGRNIP) }
        it_behaves_like :sample_company_3
      end
    end

    describe '.find_by_inn_and_ogrn' do
      it 'calls .where method' do
        expect(Ds::Spark::Company).to receive(:where).with({inn: SAMPLE_2_INN, ogrn: SAMPLE_2_OGRN}) { [company] }
        Ds::Spark::Company.find_by_inn_and_ogrn(SAMPLE_2_INN, SAMPLE_2_OGRN).should == company
      end

      it 'raises error if empty array returned' do
        expect(Ds::Spark::Company).to receive(:where) { [] }
        expect { Ds::Spark::Company.find_by_inn_and_ogrn(SAMPLE_2_INN, SAMPLE_2_OGRN) }.to raise_error(Ds::Spark::RecordNotFound)
      end
    end

    describe '.find_by_name' do
      it 'calls .where method' do
        expect(Ds::Spark::Company).to receive(:where).with({name: 'Example', region_code: 37, active: false}) { [company] }
        Ds::Spark::Company.find_by_name('Example', 37, active: false).should == company
      end

      it 'raises error if empty array returned' do
        expect(Ds::Spark::Company).to receive(:where) { [] }
        expect { Ds::Spark::Company.find_by_name('Example', 37, active: false) }.to raise_error(Ds::Spark::RecordNotFound)
      end
    end
  end
=end
end
