class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answers_params.merge(user: current_user))
    if @answer.save
      redirect_to question_path(@question), notice: t('answer.created')
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.includes(:question).find(params[:id])
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question, notice: t('answer.deleted')
    else
      head :forbidden
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
