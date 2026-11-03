require 'rails_helper'

RSpec.describe "スケジュール登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @schedule = FactoryBot.build(:schedule)
  end

  context "予定登録ができるとき" do
    it "ログインしたユーザーは新規投稿できる" do
      # ログインする
      visit user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(page).to have_current_path(root_path)
      # 新規投稿ページへのボタンがあることを確認する
      visit root_path(start_date: @schedule.date)
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
  context "予定登録できないとき" do
    it "ログインしていないユーザーは新規投稿できない" do
      # トップページに移ろうとするとログインページに遷移する
      visit root_path
      expect(page).to have_current_path(user_session_path)
    end
  end
end
RSpec.describe "スケジュール詳細", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @schedule = FactoryBot.create(:schedule, user: @user)
    @user2 = FactoryBot.create(:user)
    @schedule2 = FactoryBot.create(:schedule, user: @user2)
  end
  context "予定詳細が見れるとき" do
    it "ログインしたユーザーは自分が登録した予定を見ることができる" do
      # ログインする
      visit user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(page).to have_current_path(root_path)
      # 自分の予定詳細ページへ移動する
      click_link '予定あり',
      href: schedule_list_path(date: @schedule.date)
      click_link '詳細を見る',
      href: schedule_path(@schedule)
      # 予定の情報が表示されていることを確認する
      expect(page).to have_content(@schedule.detail)
    end
  end
  context "予定詳細が見れないとき" do
    it "ログインしたユーザーは自分以外が登録した予定を見ることはできない" do
      # ユーザー1でログインする
      visit user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(page).to have_current_path(root_path)
      # 他のユーザーの予定詳細ページに移動する
      visit schedule_path(@schedule2)
      # トップページに遷移していることを確認する
      expect(page).to have_current_path(root_path)
    end
    it "ログインしていないと予定詳細ページに遷移できない" do
      # ログインしていない状態で予定詳細ページに移動しようとするとログインページに遷移する
      visit schedule_path(@schedule)
      expect(page).to have_current_path(user_session_path)
    end
  end
end
RSpec.describe "スケジュール編集", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @schedule = FactoryBot.create(:schedule, user: @user)
  end
  context "予定編集ができるとき" do
    it "ログインしたユーザーは自分が登録した予定を編集できる" do
      # ログインする
      visit user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      find('input[name="commit"]').click
      expect(page).to have_current_path(root_path)
      # 自分の予定編集ページに移動する
      visit schedule_path(@schedule)
      click_link '編集',
      href: edit_schedule_path(schedule_path(@schedule))
      # 予定を編集する
      fill_in 'タイトル', with: '変更済み'
      fill_in 'schedule[start_time]', with: '12:34'
      fill_in 'schedule[end_time]', with: '18:00'
      fill_in 'schedule[detail]', with: 'テスト2'
      find('submit[name="commit"]').click
      # 予定の編集が完了したら詳細ページに遷移していることを確認する
      expect(page).to have_current_path(@schedule)
      # 詳細ページで編集した内容が反映されていることを確認する
      expect(page).to have_content('変更済み')
      expect(page).to have_content('12:34')
      expect(page).to have_content('18:00')
      expect(page).to have_content('テスト2')
    end
  end
end