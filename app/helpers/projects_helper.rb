module ProjectsHelper

  def added_to_projects(project_name)
    current_user.projects.pluck(:name).include?(project_name)
  end

  def has_label?(labels, name)
    labels.any?{ |label| label.name == name}
  end

  def set_default(label)
    return true if label.name == 'Backlog'
    false
  end

  def different?(issue, status, current_user)
    issue.labels.none? { |label| label.name == status }
  end

  def get_time(labels)
    labels = labels.map { |label| label.name }

    return '3000' if labels.include?('3000')
    return '1500' if labels.include?('1500')
    return '600'  if labels.include?('600')
    return '300'  if labels.include?('300')
    '5'
  end

  def set_time(time, value)
    return true if time == value
    false
  end

  def convert_time(seconds)
    case seconds
    when '5'
      "5 Seconds"
    when '300'
      "5 Minutes"
    when '600'
      "10 Minutes"
    when '1500'
      "25 Minutes"
    when '3000'
      "50 Minutes"
    end
  end

end
