class Web::Admin::ApplicationController < Web::ApplicationController
  before_filter :authenticate_admin!

  include Data::UsersListsDataHelper
end
