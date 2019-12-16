class ApplicationController < ActionController::API
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

  def restrict_resources_by_params(resources)
    resources = resources.limit(params[:limit].strip) if params[:limit].present?
    resources = resources.offset(params[:offset].strip) if params[:offset].present?
    resources
  end
end
