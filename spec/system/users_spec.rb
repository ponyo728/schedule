require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録できるとき' do
    it '正しい情報を入力するとユーザー新規登録ができてトップページに遷移する' do
      # 新規登録ページに遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # サインアップボタンを押すとユーザーモデルのカウントが1増えることを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { User.count }.by(1)
      # トップページに遷移していることを確認する
      expect(page).to have_current_path(root_path)
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報を入力するとユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # 新規登録ページに遷移する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      # サインアップボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { User.count }.by(0)
      # 新規登録ページに戻されることを確認する
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end

RSpec.describe 'ユーザーログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ユーザーログインできるとき' do
    it '正しい情報を入力するとログインできてトップページに遷移する' do
      # ログインページに遷移する
      visit user_session_path
      # ユーザー情報を入力する
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンを押す
      find('input[name="commit"]').click
      # トップページに遷移することを確認する
      expect(page).to have_current_path(root_path)
    end
  end
end
