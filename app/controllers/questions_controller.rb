class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :check_answer]
  before_action :authenticate_user!, except: [:show, :index] 

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all

  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    4.times { @question.options.build }
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @question.user = current_user

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update    
    respond_to do |format|
      if @question.update_attributes(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check_answer    
    option_id = params[:option].to_i    
    @option = Option.find(option_id)        
    respond_to do |format|
      if @option.is_answer == true
        format.html { redirect_to @question, notice: 'Correct answer' }
      else
        format.html { redirect_to @question, notice: 'Wrong answer' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:body, options_attributes: [:id, :body, :question_id, :created_at, :updated_at, :is_answer])
    end
end
