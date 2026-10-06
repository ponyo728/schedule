require 'rails_helper'

RSpec.describe Schedule, type: :model do
  before do
    @schedule = FactoryBot.build(:schedule)
  end
  
  describe '予定登録' do
    context '登録ができるとき' do
      it '正しい情報を入力すると登録できる' do
        expect(@schedule).to be_valid
      end
      it 'detailは空でも登録できる' do
        @schedule.detail = ''
        expect(@schedule).to be_valid
      end
    end
    context '登録できないとき' do
      it 'dateが空では登録できない' do
        @schedule.date = ''
        @schedule.valid?
        expect(@schedule.errors.full_messages).to include("Date can't be blank")
      end
      it 'titleが空では登録できない' do
        @schedule.title = ''
        @schedule.valid?
        expect(@schedule.errors.full_messages).to include("Title can't be blank")
      end
      it 'start_timeが空では登録できない' do
        @schedule.start_time = ''
        @schedule.valid?
        expect(@schedule.errors.full_messages).to include("Start time can't be blank")
      end
      it 'end_timeが空では登録できない' do
        @schedule.end_time = ''
        @schedule.valid?
        expect(@schedule.errors.full_messages).to include("End time can't be blank")
      end
      it 'userが紐付いていないと登録できない' do
        @schedule.user = nil
        @schedule.valid?
        expect(@schedule.errors.full_messages).to include("User must exist")
      end
    end
  end
end
