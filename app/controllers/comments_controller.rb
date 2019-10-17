class CommentsController < ApplicationController

  http_basic_authenticate_with :name => "dhh", :password => "secret", :except => [:index, :show]
  
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create!(params.require(:comment).permit!) 
    redirect_to post_path(@post) 
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end
  
  def set_comment
    @comment = Comment.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.

end
