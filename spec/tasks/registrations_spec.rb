require 'spec_helper'
require 'rake'
load File.expand_path("../../../lib/tasks/registrations.rake", __FILE__)
Rake::Task.define_task(:environment)

# Invokes specified rake task
# @param task [String] rake task name
def invoke_task(task)
  Rake::Task[task].reenable
  Rake::Task[task].invoke
end

describe 'registrations rake tasks' do
  before do
    Registration.any_instance.stub(:company_exists) { true }
    Registration.any_instance.stub(:phone_uniqueness) { true }
  end

  after do
    Registration.any_instance.unstub(:company_exists)
    Registration.any_instance.unstub(:phone_uniqueness)
  end

  describe '#find_not_notified' do
    let(:task) { 'registrations:find_not_notified' }

    shared_examples 'not notified registration' do
      it 'does not send notification right now' do
        expect { invoke_task(task) }.not_to change(ActionMailer::Base.deliveries, :count)
      end

      it 'sends notification in 15 minutes' do
        Timecop.freeze(16.minutes.since) do
          expect { invoke_task(task) }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end
    end

    context 'awaiting_verification_registration' do
      before { FactoryGirl.create(:awaiting_verification_registration) }
      it_behaves_like 'not notified registration'
    end

    context 'awaiting_password_registration' do
      before { FactoryGirl.create(:awaiting_password_registration) }
      it_behaves_like 'not notified registration'
    end

    context 'done' do
      before { FactoryGirl.create(:registration) }
      it_behaves_like 'not notified registration'
    end
  end
end
