require 'spec_helper'

describe "authentication" do

	subject { page }

	describe "signin" do

		before { visit signin_path }

		it { should have_content("Sign in") }
		it { should have_title("Sign in") }

		describe "with invalid information" do

			before { click_button "Sign in" }

			it { should have_title("Sign in") }
			it { should have_selector("div.alert.alert-error") }

			describe "after visiting another page" do

				before { click_link "Home" }
				it { should_not have_selector "div.alert.alert-error" }

			end

		end

		describe "with valid information" do

			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { should have_title(user.name) }
			it { should have_link("Users", href: users_path) }
			it { should have_link("Profile", href: user_path(user)) }
			it { should have_link("Settings", href: edit_user_path(user)) }
			it { should have_link("Sign out", href: signout_path) }
			it { should_not have_link("Sign in", href: signin_path) }

			describe "followed by sign out" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end

			describe "then try to visit sign up page" do
				before do 
					sign_in user, no_capybara: true
					get signup_path 
				end
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "then try to send POST request to users#create action" do
				let(:params) do 
					{ user: {name: user.name, email: user.email, password: user.password,
							 password_confirmation: user.password} }
				end
				before do 
					sign_in user, no_capybara: true
					post users_path, params 
				end
				specify { expect(response).to redirect_to(root_url) }
			end

		end

	end


	describe "authorization" do

		describe "for non-signed-in users" do

			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				describe "visit the edit page" do
					before { visit edit_user_path(user) }
					it {should have_title("Sign in")}
				end

				describe "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title("Sign in") }
				end

				describe "visiting the following page" do
					before { visit following_user_path(user) }
					it { should have_title("Sign in") }
				end

				describe "visiting the followers page" do
					before { visit followers_user_path(user) }
					it { should have_title("Sign in") }
				end

			end

			describe "in the Microposts controller" do

				describe "submitting to the create action" do
					before { post microposts_path }
					specify { expect(response).to redirect_to signin_path }
				end

				describe "submitting to the destroy action" do
					before { delete micropost_path(FactoryGirl.create(:micropost)) }
					specify { expect(response).to redirect_to signin_path }
				end

			end

			describe "in the Relationships controller" do

				describe "submitting to the create action" do
					before { post relationships_path }
					specify { expect(response).to redirect_to signin_path }
				end

				describe "submitting to the destroy action" do
					before { delete relationship_path(1) }
					specify { expect(response).to redirect_to signin_path }
				end

			end

			describe "when attempting to visit protected page" do
				before do
					visit edit_user_path(user)
					sign_in user
				end

				describe "after signing in" do

					describe "should render the desired protected page" do
						it { should have_title("Edit user") }
					end
					
					describe "when sign in again" do
						before do
							click_link "Sign out"
							sign_in user								
						end
						it "should be redirected to profile page" do
							expect(page).to have_title(full_title user.name)
						end
					end

				end


			end


		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user, no_capybara: true }

			describe "submitting GET request to the users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title("Edit user")) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "submitting PATCH request to the users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end

		end

	end


	describe "when not signed in" do
		before { visit root_path }
		it { should_not have_link('Profile') }
		it { should_not have_link('Settings') }
		it { should_not have_link('Sign out') }
		it { should_not have_link('Users') }
	end

end
