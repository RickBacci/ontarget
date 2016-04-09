module ReposHelper

  def get_repo_id(repo)
    current_user.repos.find_by(name: repo)
  end

  def milestone_or_repo_name(issue)
    return issue.milestone.title if issue.milestone
    current_user.current_repo
  end

  def added_to_repos(repo_name)
    current_user.repos.pluck(:name).include?(repo_name)
  end

  def has_label?(labels, name)
    labels.any?{ |label| label.name == name}
  end

  def set_default(label)
    return true if label.name == 'Backlog'
    false
  end

  def different?(issue, status)
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