module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes_for, :class_name => 'Vote', :as => :votable, :dependent => :destroy do
      def voters
        includes(:voter).map(&:voter)
      end
    end
  end


  attr_accessor :vote_registered


  def default_options
    {
      votable_id: self.id,
      votable_type: self.class.base_class.name.to_s,
      vote_flag: true,
      vote_scope: nil
    }
  end

  def vote_options(args = {})
    default_options.merge(args)
  end

  def vote_registered?
    return self.vote_registered
  end


  # voting
  def vote args = {}

    options = vote_options(args)

    self.vote_registered = false

    if options[:voter].nil?
      return false
    end

    # find the vote
    votes = votes_for.where({
      :voter_id => options[:voter].id,
      :voter_type => options[:voter].class.base_class.name,
      :vote_scope => options[:vote_scope]
    })

    if votes.count == 0
      # this voter has never voted
      vote = Vote.new(
        :votable => self,
        :voter => options[:voter],
        :vote_scope => options[:vote_scope]
      )
    else
      # this voter is potentially changing his vote
      vote = votes.last
    end

    last_update = vote.updated_at

    vote.vote_flag = options[:vote_flag]

    #Allowing for a vote_weight to be associated with every vote. Could change with every voter object
    vote.vote_weight = (options[:vote_weight].to_i if options[:vote_weight].present?) || 1

    if vote.save
      self.vote_registered = true if last_update != vote.updated_at
      update_cached_votes options[:vote_scope]
      return true
    else
      self.vote_registered = false
      return false
    end

  end

  def unvote args = {}
    return false if args[:voter].nil?
    votes = votes_for.where(:voter_id => args[:voter].id, :vote_scope => args[:vote_scope], :voter_type => args[:voter].class.base_class.name)

    return true if votes.size == 0
    votes.each(&:destroy)
    update_cached_votes args[:vote_scope]
    self.vote_registered = false if votes_for.count == 0
    return true
  end

  def vote_up voter, options={}
    self.vote :voter => voter, :vote_flag => true, :vote_scope => options[:vote_scope], :vote_weight => options[:vote_weight]
  end

  def vote_down voter, options={}
    self.vote :voter => voter, :vote_flag => false, :vote_scope => options[:vote_scope], :vote_weight => options[:vote_weight]
  end

  def vote_by voter, options={}
    self.vote :voter => voter, :vote_flag => true, :vote_scope => options[:vote_scope], :vote_weight => options[:vote_weight]
  end

  def unvote_by  voter, options = {}
    self.unvote :voter => voter, :vote_scope => options[:vote_scope] #Does not need vote_weight since the votes_for are anyway getting destroyed
  end

  def toggle_upvote(voter)
    if voter.voted_up_on? self
      self.unvote_by voter
    else
      self.vote_up voter
    end
  end

  def toggle_downvote(voter)
    if voter.voted_down_on? self
      self.unvote_by voter
    else
      self.vote_down voter
    end
    #code
  end

  def scope_cache_field field, vote_scope
    return field if vote_scope.nil?

    case field
    when :cached_votes_total=
      "cached_scoped_#{vote_scope}_votes_total="
    when :cached_votes_total
      "cached_scoped_#{vote_scope}_votes_total"
    when :cached_votes_up=
      "cached_scoped_#{vote_scope}_votes_up="
    when :cached_votes_up
      "cached_scoped_#{vote_scope}_votes_up"
    when :cached_votes_down=
      "cached_scoped_#{vote_scope}_votes_down="
    when :cached_votes_down
      "cached_scoped_#{vote_scope}_votes_down"
    when :cached_votes_score=
      "cached_scoped_#{vote_scope}_votes_score="
    when :cached_votes_score
      "cached_scoped_#{vote_scope}_votes_score"
    when :cached_weighted_total
      "cached_weighted_#{vote_scope}_total"
    when :cached_weighted_total=
      "cached_weighted_#{vote_scope}_total="
    when :cached_weighted_score
      "cached_weighted_#{vote_scope}_score"
    when :cached_weighted_score=
      "cached_weighted_#{vote_scope}_score="
    when :cached_weighted_average
      "cached_weighted_#{vote_scope}_average"
    when :cached_weighted_average=
      "cached_weighted_#{vote_scope}_average="
    end
  end

  # caching
  def update_cached_votes vote_scope = nil

    updates = {}

    if self.respond_to?(:cached_votes_total=)
      updates[:cached_votes_total] = count_votes_total(true)
    end

    if self.respond_to?(:cached_votes_up=)
      updates[:cached_votes_up] = count_votes_up(true)
    end

    if self.respond_to?(:cached_votes_down=)
      updates[:cached_votes_down] = count_votes_down(true)
    end

    if self.respond_to?(:cached_votes_score=)
      updates[:cached_votes_score] = (
        (updates[:cached_votes_up] || count_votes_up(true)) -
        (updates[:cached_votes_down] || count_votes_down(true))
      )
    end

    if self.respond_to?(:cached_weighted_total=)
      updates[:cached_weighted_total] = weighted_total(true)
    end

    if self.respond_to?(:cached_weighted_score=)
      updates[:cached_weighted_score] = weighted_score(true)
    end

    if self.respond_to?(:cached_weighted_average=)
      updates[:cached_weighted_average] = weighted_average(true)
    end

    if vote_scope
      if self.respond_to?(scope_cache_field :cached_votes_total=, vote_scope)
        updates[scope_cache_field :cached_votes_total, vote_scope] = count_votes_total(true, vote_scope)
      end

      if self.respond_to?(scope_cache_field :cached_votes_up=, vote_scope)
        updates[scope_cache_field :cached_votes_up, vote_scope] = count_votes_up(true, vote_scope)
      end

      if self.respond_to?(scope_cache_field :cached_votes_down=, vote_scope)
        updates[scope_cache_field :cached_votes_down, vote_scope] = count_votes_down(true, vote_scope)
      end

      if self.respond_to?(scope_cache_field :cached_weighted_total=, vote_scope)
        updates[scope_cache_field :cached_weighted_total, vote_scope] = weighted_total(true, vote_scope)
      end

      if self.respond_to?(scope_cache_field :cached_weighted_score=, vote_scope)
        updates[scope_cache_field :cached_weighted_score, vote_scope] = weighted_score(true, vote_scope)
      end

      if self.respond_to?(scope_cache_field :cached_votes_score=, vote_scope)
        updates[scope_cache_field :cached_votes_score, vote_scope] = (
          (updates[scope_cache_field :cached_votes_up, vote_scope] || count_votes_up(true, vote_scope)) -
          (updates[scope_cache_field :cached_votes_down, vote_scope] || count_votes_down(true, vote_scope))
        )
      end

      if self.respond_to?(scope_cache_field :cached_weighted_average=, vote_scope)
        updates[scope_cache_field :cached_weighted_average, vote_scope] = weighted_average(true, vote_scope)
      end
    end

    if (::ActiveRecord::VERSION::MAJOR == 3) && (::ActiveRecord::VERSION::MINOR != 0)
      self.update_attributes(updates, :without_protection => true) if updates.size > 0
    else
      self.update_attributes(updates) if updates.size > 0
    end

  end


  # results
  def get_up_votes options={}
    vote_scope_hash = scope_or_empty_hash(options[:vote_scope])
    votes_for.where({:vote_flag => true}.merge(vote_scope_hash))
  end

  def get_down_votes options={}
    vote_scope_hash = scope_or_empty_hash(options[:vote_scope])
    votes_for.where({:vote_flag => false}.merge(vote_scope_hash))
  end


  # counting
  def count_votes_total skip_cache = false, vote_scope = nil
    if !skip_cache && self.respond_to?(scope_cache_field :cached_votes_total, vote_scope)
      return self.send(scope_cache_field :cached_votes_total, vote_scope)
    end
    votes_for.where(scope_or_empty_hash(vote_scope)).count
  end

  def count_votes_up skip_cache = false, vote_scope = nil
    if !skip_cache && self.respond_to?(scope_cache_field :cached_votes_up, vote_scope)
      return self.send(scope_cache_field :cached_votes_up, vote_scope)
    end
    get_up_votes(:vote_scope => vote_scope).count
  end

  def count_votes_down skip_cache = false, vote_scope = nil
    if !skip_cache && self.respond_to?(scope_cache_field :cached_votes_down, vote_scope)
      return self.send(scope_cache_field :cached_votes_down, vote_scope)
    end
    get_down_votes(:vote_scope => vote_scope).count
  end

  def count_votes_score skip_cache = false, vote_scope = nil
    if !skip_cache && self.respond_to?(scope_cache_field :cached_votes_score, vote_scope)
      return self.send(scope_cache_field :cached_votes_score, vote_scope)
    end
    ups = count_votes_up(true, vote_scope)
    downs = count_votes_down(true, vote_scope)
    ups - downs
  end

  def weighted_total skip_cache = false, vote_scope = nil
    if !skip_cache && self.respond_to?(scope_cache_field :cached_weighted_total, vote_scope)
      return self.send(scope_cache_field :cached_weighted_total, vote_scope)
    end
    ups = get_up_votes(:vote_scope => vote_scope).sum(:vote_weight)
    downs = get_down_votes(:vote_scope => vote_scope).sum(:vote_weight)
    ups + downs
  end

  def weighted_score skip_cache = false, vote_scope = nil
    if !skip_cache && self.respond_to?(scope_cache_field :cached_weighted_score, vote_scope)
      return self.send(scope_cache_field :cached_weighted_score, vote_scope)
    end
    ups = get_up_votes(:vote_scope => vote_scope).sum(:vote_weight)
    downs = get_down_votes(:vote_scope => vote_scope).sum(:vote_weight)
    ups - downs
  end

  def weighted_average skip_cache = false, vote_scope = nil
    if !skip_cache && self.respond_to?(scope_cache_field :cached_weighted_average, vote_scope)
      return self.send(scope_cache_field :cached_weighted_average, vote_scope)
    end

    count = count_votes_total(skip_cache, vote_scope).to_i
    if count > 0
      weighted_score(skip_cache, vote_scope).to_f / count
    else
      0.0
    end
  end

  # voters
  def voted_on_by? voter
    votes = votes_for.where(:voter_id => voter.id, :voter_type => voter.class.base_class.name)
    votes.count > 0
  end

  private

  def scope_or_empty_hash(vote_scope)
    vote_scope ? { :vote_scope => vote_scope } : {}
  end
end
