class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answers_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = t('answer.created')
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.includes(:question).find(params[:id])
    @question = @answer.question
    if current_user.id != @answer.user_id
      render nothing: true, status: :forbidden
      return
    end
    @answer.destroy
    flash[:notice] = t('answer.deleted')
    redirect_to @question
  end

  private

  def answers_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
