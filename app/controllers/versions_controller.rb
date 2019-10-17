class VersionsController < ApplicationController
  def revert
    version = @post.versions.find(params[:version])
    @version.reify.save! 
    redirect_to :back, :notice => "Undid #{@version.event}"
  end
end
