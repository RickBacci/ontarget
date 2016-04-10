class IssuesController < ApplicationController
  include GithubCardStatusUpdater
  include GithubIssueCreater
  include GithubIssueUpdater
  include GithubIssueLabelUpdater

  def new
    @repo = Repo.find_by(name: params[:repo_name])
    client.repo = @repo.name

    @labels ||= client.issues.labels.list
  end

  def update_issue_times
    repo = Repo.find_by(name: params[:repo])
    set_client_repo_name(repo)

    issue_number  = params[:issue_number]
    original_time = params[:time]
    new_time      = params[:timer_time]

    client.issues.labels.add client.user, client.repo, issue_number, new_time
    client.issues.labels.remove client.user, client.repo, issue_number, label_name: original_time

    flash[:success] = "Timer Updated!"

    redirect_to repo_path(repo)
  end

  def self.update_issue_labels
    @update_issue_labels || GithubIssueLabelUpdater
  end

  def self.update_issue_labels=(update_issue_labels)
    @update_issue_labels = update_issue_labels
  end

  def update_issue_labels
    repo = Repo.find_by(name: params[:repo])
    set_client_repo_name(repo)

    IssuesController.update_issue_labels.call(client: current_user.github,
                                              number: params[:number],
                                              labels: params[:updates][:labels])

    flash[:success] = "Labels Updated!"
    redirect_to repo_path(repo.id)
  end


  def self.create
    @create || GithubIssueCreater
  end

  def self.create=(create)
    @create = create
  end

  def create
    repo = Repo.find_by(name: params[:repo_name])
    client.repo = repo.name

    labels = params.has_key?(:creation) ? params[:creation][:labels] : []

    labels << params[:timer_time] << 'Backlog'

    IssuesController.create.call(client: current_user.github,
                                 title:  params[:title],
                                 body:   params[:body],
                                 labels: labels)

    flash[:success] = "Issue Created!"
    redirect_to repo_path(repo)
  end


  def self.update
    @update || GithubIssueUpdater
  end

  def self.update=(update)
    @update = update
  end

  def update
    repo = Repo.find_by(name: params[:repo])
    set_client_repo_name(repo)

    IssuesController.update.call(client: current_user.github,
                                 number: params[:number],
                                 title:  params[:title],
                                 body:   params[:body],
                                 labels: params[:labels].split)

    flash[:success] = "Issue Updated!"
    redirect_to repo_path(repo)
  end

  def self.update_card_status
    @update_card_status || GithubCardStatusUpdater
  end

  def self.update_card_status=(update_card_status)
    @update_card_status = update_card_status
  end

  def update_card_status

    IssuesController.update_card_status.call(
      client:     client,
      owner:      params[:owner],
      repo:       params[:repo],
      number:     params[:number],
      old_column: params[:oldcolumn],
      new_column: params[:newcolumn])

    head :ok
  end

  private

  def client
    current_user.github
  end
end

