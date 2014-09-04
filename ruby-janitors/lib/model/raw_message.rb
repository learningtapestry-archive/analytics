class RawMessage < ActiveRecord::Base
  # stub method for children to override (simply here to document common method signatures for children)
  # 
  def each_new_row(opts ={}, &block)
    # support opts:
    #  :yield => Max number of rows to iterate over
  end
end

class RawCodeAcademy < RawMessage
  def self.each_row(opts = {}, &block)
    # opts:
    #   :limit => [max rows to iterate over]
    #   :status => ["READY"] - type of rows to iterate over
    limit = opts[:limit] || 50
    status = opts[:status] || (raise ParameterMissing.new)
    # lock rows that we are going to work on
    # grab ids of all locked rows
    msg_ids = ActiveRecord::Base.connection.exec_query("select id from raw_messages limit #{limit}")
       # TODO Make sql pull only code academy raw_messages that haven't or aren't being processed
    # grab first locked row
    # pass row to iterator block
    # ensure we change status on all locked rows
  end
end
