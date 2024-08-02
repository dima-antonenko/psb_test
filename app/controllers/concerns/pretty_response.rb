module PrettyResponse
  def render_collection(item, options = {})
    render_errors(item, 422) and return if item.is_a?(ActiveModel::Errors)
    render_forbidden and return  if item.nil?

    serializer = build_serializer(item, options.fetch(:serializer, nil))
    prm = { current_user: current_user }.merge(options.fetch(:extra_params, {}))

    output = {items: serializer.render_as_hash(item, prm)}
    output.merge!({meta: options.fetch(:meta, nil)})
    render_json(output)
  end

  def render_item(item, options = {})
    render_errors(item, 422) and return if item.is_a?(ActiveModel::Errors)
    render_forbidden and return  if item.nil?

    serializer = build_serializer(item, options.fetch(:serializer, nil))
    prm = { current_user: current_user }.merge(options.fetch(:extra_params, {}))

    output = serializer.render_as_hash(item, prm)
    render_json(output)
  end

  def render_errors(errors, code)
    render_json({errors: errors}, code)
  end

  def render_forbidden
    render_json({ message: 'Something went wrong' }, 500)
  end

  def render_json(json = {}, code = 200)
    render(json: json, status: code)
  end

  private

  def get_serializer(item, serializer)
    if serializer
      serializer
    else
      serializer_class(item)
    end
  end

  def serializer_class(item)
    if item.is_a?(ActiveRecord::Base) # if one record
      "#{item.class.name}Blueprint"
    elsif item.size > 0 # if collection
      "#{item.first.class.name}Blueprint"
    end
  end

  def build_serializer(item, serializer_class)
    get_serializer(item, serializer_class).classify.safe_constantize
  end
end
