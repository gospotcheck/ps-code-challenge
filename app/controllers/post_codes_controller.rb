class PostCodesController < ApplicationController
  def index
    @data = PostCodeData.all
  end
end