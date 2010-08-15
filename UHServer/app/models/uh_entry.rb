# methods add to UH entries, including annotations, comments, etc.
module UhEntry
  STAT_TIME_POINT = "2000-01-01 0:0:0".to_time
  

  # get paginated entries of given ids within the interval specified by
  # start_time and end_time.
  def paginate_entries_within_interval(entity_opts={}, query_opts={})
    results = []
    
    created_str = entity_opts[:date_field_str] || "created_at"
    include = entity_opts[:include] || ""
    ref_id = entity_opts[:ref_id_name] || ""
    
    if query_opts.empty? || ((query_opts[:ids].nil? || query_opts[:ids].empty?) && query_opts[:start_time].nil? && query_opts[:end_time].nil?)
      return results
    end
    # set start_time and end_time. 
    # 1. start_time is nil, but end_time isn't, that means every time until end_time
    # 2. end_time is nil, but start_time isn't, that means every time from start_time to now
    # 3. both are nil, means all time
    start_time = query_opts[:start_time] || STAT_TIME_POINT
    end_time = query_opts[:end_time] || Time.now
    
    if entity_opts[:date_in_number]
      # the datetime store in db is in number
      start_time = start_time.to_i * 1000
      end_time = end_time.to_i * 1000
    end
    
    if (query_opts[:ids].nil? || query_opts[:ids].empty?)
      results = self.paginate(:all, :page => query_opts[:page], :per_page => query_opts[:per_page], 
                              :include => include,
                              :order => "#{ref_id} DESC, #{created_str} DESC",
                              :conditions => [
                                "#{created_str} >= ? and #{created_str} < ?",
                                start_time,
                                end_time
                              ])
    else
      ids = query_opts[:ids]
      results = self.paginate(:all, :page => query_opts[:page], :per_page => query_opts[:per_page], 
                              :include => include, 
                              :order => "#{ref_id} DESC, #{created_str} DESC",
                              :conditions => [
                                "#{ref_id} in (?) and #{created_str} >= ? and #{created_str} < ?",
                                ids,
                                start_time,
                                end_time
                              ])
    end
    results
  end
    
  # get entries made today
  def paginate_entries_today(entity_opts,opts)
    opts[:start_time] = Time.now.yesterday
    opts[:end_time] = Time.now
    paginate_entries_within_interval(entity_opts,opts)
  end
  
  # get entries made this week
  def paginate_entries_a_week(entity_opts,opts)
    opts[:start_time] = Time.now.last_week
    opts[:end_time] = Time.now
    paginate_entries_within_interval(entity_opts,opts)
  end
  
  # get entries made this month
  def paginate_entries_a_month(ref_id_name,opts)
    opts[:start_time] = Time.now.last_month
    opts[:end_time] = Time.now
    paginate_entries_within_interval(entity_opts,opts)
  end
  
  # get entries made this year
  def paginate_entries_a_year(entity_opts,opts)
    opts[:start_time] = Time.now.last_year
    opts[:end_time] = Time.now
    paginate_entries_within_interval(entity_opts,opts)
  end
end