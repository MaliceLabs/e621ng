class TagsController < ApplicationController
  before_action :member_only, :only => [:edit, :update, :preview]
  respond_to :html, :json

  def edit
    @tag = Tag.find(params[:id])
    check_privilege(@tag)
    respond_with(@tag)
  end

  def index
    @tags = Tag.search(search_params).paginate(params[:page], :limit => params[:limit], :search_count => params[:search])

    respond_with(@tags)
  end

  def autocomplete
    @tags = Tag.names_matches_with_aliases(params[:search][:name_matches])

    expires_in params[:expiry].to_i.days if params[:expiry]

    respond_with(@tags) do |fmt|
      fmt.json do
        render json: @tags.to_json
      end
    end
  end

  def preview
    @preview = TagsPreview.new(tags: params[:tags])
    respond_to do |format|
      format.json do
        render json: @preview.serializable_hash
      end
    end
  end

  def show
    if params[:id] =~ /\A\d+\z/
      @tag = Tag.find(params[:id])
    else
      @tag = Tag.find_by_name(params[:id])
    end
    respond_with(@tag)
  end

  def update
    @tag = Tag.find(params[:id])
    check_privilege(@tag)
    @tag.update(tag_params)
    respond_with(@tag)
  end

  private

  def check_privilege(tag)
    raise User::PrivilegeError unless tag.category_editable_by?(CurrentUser.user)
  end

  def tag_params
    permitted_params = [:category]
    permitted_params << :is_locked if CurrentUser.is_moderator?

    params.require(:tag).permit(permitted_params)
  end

  def allowed_readonly_actions
    super + %w[autocomplete]
  end
end
