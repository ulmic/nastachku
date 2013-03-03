class Web::LectorsController < Web::ApplicationController
  def index
    @lectors = User.activated.as_lectors.by_created_at.ransack(params[:q]).result
    if params[:q]
      @topic = Topic.find params[:q][:topics_id_eq]
      title @topic
    end
  end
end
