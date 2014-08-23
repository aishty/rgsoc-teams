require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  context 'ability' do
    subject {ability}

    let(:ability) { Ability.new(user) }

    context 'when a user is connected' do
      let(:user) { FactoryGirl.create(:user) }
      describe 'she/he is allowed to do everything on her/his account' do
        it { ability.should be_able_to(:show, user) }
        it { ability.should_not be_able_to(:create, User.new) } #this only happens through GitHub
      end

      context 'when a user is admin' do
        let(:user) { FactoryGirl.create(:user) }
        let(:organizer_role) { FactoryGirl.create(:organizer_role, user: user) }
        it "should be able to CRUD on anyone's account" do
          expect(subject).to be_able_to(:crud, organizer_role)
        end
      end

      describe 'she/he is not allowed to CRUD on someone else account' do
        let(:other_user) { FactoryGirl.create(:user) }
        it { ability.should_not be_able_to(:show, other_user) }
      end

      describe 'a user should not be able to mark another\'s attendance to a conference' do

        context 'when same user' do
          let!(:user) { FactoryGirl.create(:user) }
          let!(:attendance) { FactoryGirl.create(:attendance, user: user)}

          it 'allows marking of attendance' do
            ability.should be_able_to(:crud, attendance)
          end

          context 'when user is admin' do
            let!(:user) { FactoryGirl.create(:user) }
            let!(:organiser_role) { FactoryGirl.create(:organizer_role, user: user)}
            it "should be able to crud attendance" do
              expect(subject).to be_able_to :crud, attendance
            end
          end
        end

        context 'when different users' do
          let!(:other_user) { FactoryGirl.create(:user)}
          let!(:attendance) { FactoryGirl.create(:attendance, user: user)}
          it { ability.should_not be_able_to(:crud, other_user.attendances) }

        end
      end

      describe 'access to mailings' do
        let!(:mailing) { Mailing.new }
        let!(:user) { FactoryGirl.create(:student) }

        context 'when user is admin' do
          let(:user) { FactoryGirl.create(:organizer) }

          it { expect(subject).to be_able_to :crud, mailing }
        end

        context 'when user is a recipient' do
          it 'allows to read' do
            mailing.to = %w(students)
            expect(subject).to be_able_to :read, mailing
          end
        end

        context 'when user has nothing to do with the mailing' do
          it 'will not allow to read' do
            expect(subject).not_to be_able_to :read, mailing
          end
        end
      end

      context 'permitting activities' do
        context 'for feed_entries' do
          it 'allows anyone to read' do
            expect(Ability.new(nil)).to be_able_to :read, :feed_entry
          end
        end

        context 'for mailings' do
          it 'does not allow anonymous user to read' do
            expect(Ability.new(nil)).not_to be_able_to :read, :mailing
          end
          it 'allows signed in user to read' do
            expect(subject).to be_able_to :read, :mailing
          end
        end
      end
    end
  end

  context 'to join helpdesk team' do
    let(:user) { FactoryGirl.create(:helpdesk) }
    let(:team) { FactoryGirl.create(:team) }

    subject { ability }
    let(:ability) { Ability.new(user) }

    it 'should be logged in' do
      expect(ability.signed_in?(user)).to eql true
    end

    it 'should not be part of existing team' do
      expect(ability.on_team?(user, team)).to eql false
    end

    it 'should be able to join helpdesk team' do
      helpdesk_team = FactoryGirl.create(:team, :helpdesk)
      ability.should be_able_to(:join, helpdesk_team)
    end
  end


  describe 'user role' do
    it 'should be able to supervise' do
      user =  FactoryGirl.create(:user)
      FactoryGirl.create(:organizer_role, user: user )
      team = FactoryGirl.create(:team)
      ability = Ability.new(user)
      expect(ability).to be_able_to(:supervise, team)
    end
  end
end




