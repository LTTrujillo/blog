class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  http_basic_authenticate_with :name => "dhh", :password => "secret", :except => [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    respond_to do |format|
      format.html #index.html.erb
      format.json {render :json => @posts }
    end
  end
  
  # GET /posts/1
  # GET /posts/1.json
  def show
    
    @post = Post.find(params[:id])
    @versions = @post.versions.all
    # @versions = @post.versions.find(params[:version])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  def show_version
    # version = @post.versions.find(params[:version])
    @current_id = params[:id]
    @vid = params[:vid]
    version = PaperTrail::Version.find_by(:id => params[:vid])
    @post = version.reify
   
    # binding.remote_pry
    render :show_version
  end

  def rollback
    # binding.remote_pry
    @post = Post.find(params[:id])
    version = @post.versions.find(params[:vid])
    if version.reify.save
      redirect_to post_path(@post.id), notice: 'Post was successfully rollbacked.'
    else
      render :show
    end
  end



  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
      
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy 
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :title, :content, :tags_attributes => [:name, :id, :_destroy], :versions_attributes => [:id, :name, :title, :content, :changed_object])
    end
end
