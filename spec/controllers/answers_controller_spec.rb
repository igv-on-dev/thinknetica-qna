require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    context 'authenticated user' do
      sign_in_user

      before { get :new, question_id: question }

      it 'assigns a new Answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'non authenticated user' do
      it 'redirects to ' do
        expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer) }
            .to_not change(Answer, :count)
      end
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new answer in the database and link it with right question' do
          expect{ post :create, question_id: question, answer: attributes_for(:answer) }
              .to change(question.answers, :count).by(1)
        end

        it 'redirects to question view' do
          expect(post :create, question_id: question, answer: attributes_for(:answer))
              .to redirect_to question
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect{ post :create, question_id: question, answer: attributes_for(:invalid_answer) }
              .to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, question_id: question, answer: attributes_for(:invalid_answer)
          expect(response).to render_template :new
        end
      end
    end

    context 'non authenticated user' do
      it 'does not save the answer and redirects to new_user_session_path' do
        expect{ post :create, question_id: question, answer: attributes_for(:answer) }
            .to_not change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    let!(:answer) { create(:answer, question: question, user: @user) }
    let!(:another_user_answer) { create(:answer, question: question) }

    context 'current_user is author of answer' do
      it 'deletes answer of right question' do
        expect{ delete :destroy, id: answer }.to change(question.answers, :count).by(-1)
      end

      it 'deletes answer of right user' do
        expect{ delete :destroy, id: answer }.to change(@user.answers, :count).by(-1)
      end

      it 'redirects to question view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question
      end
    end

    context 'current_user is not author of answer' do
      it 'does not delete answer' do
        expect{ delete :destroy, id: another_user_answer }.to_not change(Answer, :count)
      end

      it 'renders error 403' do
        delete :destroy, id: another_user_answer
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
