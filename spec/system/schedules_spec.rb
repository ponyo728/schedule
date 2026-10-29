require 'rails_helper'

RSpec.describe "スケジュール登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @schedule = FactoryBot.build(:schedule)
  end

  context "予定登録ができるとき"do
    it "ログインしたユーザーは新規投稿できる" do
      # ログインする
      visit user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(page).to have_current_path(root_path)
      # 新規投稿ページへのボタンがあることを確認する
      visit root_path(start_date: @schedule.date)
      sleep(1)
      click_link '登録する', href: new_schedule_path(date: @schedule.date)
      # 投稿ページに移動する
      expect(page).to have_current_path(new_schedule_path(date: @schedule.date))
      # フォームに必要な情報を入力する
      fill_in 'タイトル', with: @schedule.title
      fill_in 'schedule[start_time]', with: @schedule.start_time
      fill_in 'schedule[end_time]', with: @schedule.end_time
      fill_in 'schedule[detail]', with: @schedule.detail
      # 送信するとScheduleモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
        sleep(1)
      }.to change { Schedule.count }.by(1)
      # 新規投稿した日付に予定ありと書いてあるリンクがあることを確認する
      expect(page).to have_link(
      '予定あり',
      href: schedule_list_path(date: @schedule.date)
      )
      # 予定一覧ページに移動する
      click_link '予定あり',
      href: schedule_list_path(date: @schedule.date)
      # 先ほど登録した情報があることを確認する
      expect(page).to have_content(@schedule.title)
    end
  end
end
