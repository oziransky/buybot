require 'spec_helper'
require 'faker'

describe PagesController do

  login_user

  before (:each) do
    ActionMailer::Base.deliveries.clear

    # run the background job without delay
    Delayed::Worker.delay_jobs = false
  end

  it "should have a valid user signed in" do

    subject.current_user.should_not be_nil

  end

  it "should get new invitation form" do

    get :new_invite

    response.should be_success

  end

  it "should send invite email to a friend" do

    email = Faker::Internet.email
    message = Faker::Lorem.sentence(2)

    post :invite_friends, :email => email, :message => message

    # verify emails
    ActionMailer::Base.deliveries.should_not be_empty

    response.should redirect_to(root_path)
  end
end