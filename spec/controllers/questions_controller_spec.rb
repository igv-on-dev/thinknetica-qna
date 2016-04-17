require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question)}

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'authenticated user' do
      sign_in_user

      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(request).to render_template :new
      end
    end

    context 'non authenticated user' do
      before { get :new }

      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new question in the database' do
          expect{ post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect{ post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end

        it 're-renders create view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template(:new)
        end
      end
    end

    context 'non authenticated user' do
      it 'does not save the question and redirects to new_user_session_path' do
        expect{ post :create, question: attributes_for(:question) }.to_not change(Question, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: { title: 'new title', body: 'new body' }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil } }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq attributes_for(:question)[:title]
        expect(question.body).to eq attributes_for(:question)[:body]
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      sign_in_user

      let!(:question) { create(:question, user: @user) }
      let!(:another_user_question) { create(:question) }

      context 'current_user is author of the question' do
        it 'deletes question of right user' do
          expect{ delete :destroy, id: question }.to change(@user.questions, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, id: question
          expect(response).to redirect_to questions_path
        end
      end

      context 'current_user is not author of the question' do
        it 'does not delete question' do
          expect{ delete :destroy, id: another_user_question }.to_not change(Question, :count)
        end

        it 'renders error 403' do
          delete :destroy, id: another_user_question
          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
