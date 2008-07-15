module TagsHelper
  # See the README for an example using tag_cloud.
  def tag_cloud(tags, classes)
    max_count = tags.sort_by(&:length).last.length.to_f
    
    tags.each do |tag|
      index = ((tag.length / max_count) * (classes.size - 1)).round
      yield tag, classes[index]
    end
  end
end