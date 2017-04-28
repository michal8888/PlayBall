class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy]
  before_action :require_user, only: %i[create update destroy]
  before_action :require_same_user_for_comments, only: %i[update destroy]

  def create
    @comment = Court.find(params[:court_id]).comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = "Comment was successfully created!"
    elsif params[:content].nil?
      flash[:danger] = "Comment can't be empty"
    else
      flash[:danger] = "Comment was not added. Please try again"
    end
    redirect_to court_path(params[:court_id])
  end

  def update
    if @comment.update(comment_params)
      flash[:info] = "Comment was successfully updated"
      redirect_to court_path(params[:court_id])
    elsif params[:content].nil?
      flash[:danger] = "Comment can't be empty"
      redirect_to court_path(params[:court_id])
    else
      flash[:danger] = "Comment was not updated. Please try again."
      render "edit"
    end
  end

  def edit; end

  def destroy
    @comment.destroy
    flash[:danger] = "Comment was successfully deleted"
    redirect_to court_path(@comment.court_id)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
