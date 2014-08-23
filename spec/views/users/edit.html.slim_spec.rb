require 'spec_helper'

describe 'users/edit' do
  let(:user) {
    stub_model(
      User,
      name: 'MyString',
      email: 'MyString',
      location: 'MyString',
      bio: 'MyString',
      homepage: 'MyString',
      role: 'coach',
      is_company: false,
      company_name: 'Company name',
      company_info: 'Company info'
    )
  }

  before(:each) do
    @user = assign(:user, user)
    controller.stub(:current_user).as_null_object
  end

  it 'renders the edit user form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', user_path(@user), 'post' do
      assert_select 'input#user_name[name=?]', 'user[name]'
      assert_select 'input#user_email[name=?]', 'user[email]'
      assert_select 'input#user_location[name=?]', 'user[location]'
      assert_select 'textarea#user_bio[name=?]', 'user[bio]'
      assert_select 'input#user_homepage[name=?]', 'user[homepage]'
      assert_select 'select#user_country[name=?]', 'user[country]'
      assert_select 'input#user_hide_email[name=?]', 'user[hide_email]'
      assert_select 'input#user_is_company[name=?]', 'user[is_company]'
      assert_select 'input#user_company_name[name=?]', 'user[company_name]'
      assert_select 'textarea#user_company_info[name=?]', 'user[company_info]'
    end
  end
end
