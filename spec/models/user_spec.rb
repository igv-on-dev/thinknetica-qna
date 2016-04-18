require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  describe '#author_of?' do
    subject { create(:user) }

    context 'question' do
      let!(:users_question) { create(:question, user: subject) }
      let!(:other_question) { create(:question) }

      it { is_expected.to be_author_of(users_question)}
      it { is_expected.not_to be_author_of(other_question)}
    end

    context 'answer' do
      let!(:users_answer) { create(:answer, user: subject) }
      let!(:other_answer) { create(:answer) }

      it { is_expected.to be_author_of(users_answer)}
      it { is_expected.not_to be_author_of(other_answer)}
    end

    context 'user and item are not persisted' do
      subject { build(:user) }
      let!(:question) { build(:question, user_id: nil) }
      let!(:answer) { build(:answer, user_id: nil) }

      it { is_expected.not_to be_author_of(question)}
      it { is_expected.not_to be_author_of(answer)}
    end
  end
end
