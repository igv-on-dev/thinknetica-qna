class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answers_params)
    if @answer.save
      flash[:notice] = t('answer.created')
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  private

  def answers_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
