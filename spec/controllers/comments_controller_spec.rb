require 'spec_helper'

describe CommentsController do

  let(:valid_attributes) { { "text" => Faker::Lorem.paragraph } }
  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }
  let(:application) { FactoryGirl.create(:application) }

  before do
    CommentMailer.stub(:email).and_return(double("Mailer", :deliver => true))

    user.roles.create(name: 'organizer')
    sign_in user
  end

  describe "POST create" do
    describe "with valid params" do
      context 'team comment' do
        it "creates a new Comment" do
          expect {
            post :create, {:comment => valid_attributes.merge(team_id: team.id)}, valid_session
          }.to change(Comment, :count).by(1)
        end

        it "redirects to the team page" do
          post :create, {:comment => valid_attributes.merge(team_id: team.id)}, valid_session
          response.should redirect_to(team)
        end
      end

      context 'applications comment' do
        it "creates a new Comment" do
          expect {
            post :create, {:comment => valid_attributes.merge(application_id: application.id)}, valid_session
          }.to change(Comment, :count).by(1)
        end

        it "redirects to the team page" do
          post :create, {:comment => valid_attributes.merge(application_id: application.id)}, valid_session
          response.should redirect_to(application)
        end
      end
    end
  end
end
