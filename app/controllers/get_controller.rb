class GetController < ApplicationController
  def dont_do_that
    render json: {:status => 401, :error => "Unauthorized: there is nothing for you to get!!"}, status: :unauthorized
  end
end
