class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :check_answer]
  before_action :authenticate_user!, except: [:show, :index] 

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.paginate(page: params[:page], per_page: 2)

  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
    @question.options.build
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if params[:add_option]
      @question.options.build
    else
      respond_to do |format|
        if @question.save
          format.html { redirect_to @question, notice: 'Question was successfully created.' and return }
          format.json { render :show, status: :created, location: @question }          
        else
          format.html { render :new }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    end
    render :action => 'new'
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    @question = Question.find(params[:id])
    if params[:add_option]
      # rebuild the ingredient attributes that doesn't have an id
      unless params[:question][:options_attributes].blank?
        for attribute in params[:question][:options_attributes]
          @question.options.build(attribute.last.except(:_destroy)) unless attribute.last.has_key?(:id)
        end
      end
      # add one more empty ingredient attribute
      @question.options.build
    elsif params[:remove_option]
      # collect all marked for delete ingredient ids      
      removed_options = []
      params[:question][:options_attributes].each do |k,v|
        if v["_destroy"].to_i == 1
          removed_options << v["id"]
        end
      end
      puts(removed_options)
      # physically delete the options from database
      Option.delete(removed_options)
      flash[:notice] = "Options removed."
      for attribute in params[:question][:options_attributes]
        # rebuild ingredients attributes that doesn't have an id and its _destroy attribute is not 1
        @question.options_attributes.build(attribute.last.except(:_destroy)) if (!attribute.last.has_key?(:id) && attribute.last[:_destroy].to_i == 0)
      end
    else    
      respond_to do |format|
        if @question.update_attributes(question_params)
          format.html { redirect_to @question, notice: 'Question was successfully updated.' and return }
          format.json { render :show, status: :ok, location: @question }
        else
          format.html { render :edit }
          format.json { render json: @question.errors, status: :unprocessable_entity }
        end
      end
    end
    render :action => 'edit'
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

      # result = params.require(:question).permit(:body, :answer_id, options_attributes: [:id, :body, :question_id])

      # answer_id = result.delete(:answer_id)

      # # result[:options_attributes].each do |a|
      # #   puts(a)
      # # end

      # result[:options_attributes].each do |option_attrs|
        
      #     option_attrs[:is_answer] = option_attrs[:question_id] == option_id
        
        
      # end

      # result
    end
end
