require 'benchmark'
require 'tempfile'
require 'zlib'
DB_POSTGRESQL = true
=begin
Methods to focus on for the functions you want:

TableLoader.simple_import_data_from_file
  Simple method to load data into a table from a csv file (default '|' delimited I think)
  Note You pass in an AR model which drives some of the decisions about file and table names, I think
  Note :delete_existing_data=>false option
TableLoader.copy_from_file_to_table
  Actually does the work of importing from a file into a table  

TableLoader::save_to_file_from_ar
  This will save data to a file based on an ActiveRecord model you pass in
TableLoader::save_to_file_from_table
  Actually does the work of exporting from a table to a file
=end

# moves data between files and tables
module TableLoader
  # loads all tables from files - excludes certain system tables unless specifically
  # instructed to include them with option :load_system_tables => true
  # specify location for source files with :source_path => '[path_to_files]'
  def TableLoader::load_all_tables_from_files(options = {})
    if RAILS_ENV_PRODUCTION
      puts "*********************************************************************"
      puts "You are attempting to re-load ALL data tables into the production database."
      puts "This is very likely a mistake."
      puts "You should cancel this operation unless you are certain this is NOT a mistake."
      puts "Unless you are recovering from a catastrophic data failure, do not continue."
      puts "**********************************************************************"
      puts "Press [enter] to continue or ctrl-c to cancel"
      STDIN::gets
      puts "Press [enter] once more to continue or ctrl-c to cancel"
      STDIN::gets
    end
    load_system_tables = options[:load_system_tables] || false
    source_path = options[:source_path] || DUMP_DATA_PATH
    tables = AppUtils::TableLoader::get_table_names(:exclude_system_tables => !load_system_tables)
    tables.each do |table_name|
      file_name = File::join(DUMP_DATA_PATH, "#{table_name}.txt.gz")
      if !File::exists?(file_name)
        puts "** Unable to find file #{file_name}. Skipping.."
      else
        TableLoader.simple_import_data_from_file(table_name, file_name)
      end
    end
  end

  # simple method for loading a specific file into a specific model
  # defaults: delimiter "|", null "[[NULL]]"
  # ar_model can be passed as an ActiveRecord class or in string "table_name" format
  # if file_name ends with ".gz" then we will unzip this file, load contents and remove the unzipped file
  # THIS METHOD DELETES EXISTING DATA IN TABLES BY DEFAULT
  def TableLoader.simple_import_data_from_file(ar_model, file_name, options = {})
    # convert string table names to actual activerecord models, when ar_model is passed
    # in as a string instead of a proper activerecord class
    begin
      if ar_model.kind_of?(String) : ar_model = ActiveSupport::Inflector::constantize(ActiveSupport::Inflector::camelize(ar_model)); end
    rescue NameError => e
      puts "Unable to find ActiveRecord model for table name #{ar_model}. Aborting data load for this object."
      return false
    end
    delimiter = options[:delimiter] || '|'
    null = options[:null] || '[[NULL]]'
    delete_existing_data = options[:delete_existing_data]
    delete_existing_data = true if delete_existing_data == nil
    quiet = options[:quiet] || false
    if file_name.match(%r{\.gz$})
      zip_file_name = file_name.dup
      file_name.gsub!(%r{\.gz$}, '')
      unzip_file = true
      if File::exists?(zip_file_name)
        AppUtils::unzip_file(zip_file_name)
      elsif File::exists?(file_name)
        puts "Using unzipped file because zipped file cannot be found:\n  #{file_name}" unless quiet
        unzip_file = false
      else
        puts "Cannot find data file #{zip_file_name}, aborting load for this object."
        return false
      end
    else
      unzip_file = false
    end

    if !File::exists?(file_name)
      raise CoreERR_RailsEnvironment, "Can't complete import: File '#{file_name}' not Found. Generally source data can be found in SVN:./bedrock/trunk/db_core/db/migrate/data..."
    end

    columns = ""
    #load the first row from this file, and use it as the column row
    File::open(file_name, 'r') do |source|
      columns = source.gets
      columns.gsub!(delimiter,',')
    end
    retval = AppUtils::get_timing_as_migration("Loaded #{ar_model.to_s} from #{file_name}") {
      AppUtils::TableLoader::copy_from_file_to_table(ar_model.table_name, columns, file_name,
        {:delete_existing_data => delete_existing_data, :skip_header_row => true,
         :sql_parameters => "WITH DELIMITER '#{delimiter}' NULL '#{null}'", :ar_model => ar_model,
         :reset_id_sequence => ar_model})
    }
    File::delete(file_name) if unzip_file
    puts retval unless quiet
    retval
  end

  IMPORT_NULL = '[[NULL]]'
  IMPORT_DELIMITER = '|'
  def TableLoader.import_data_from_file(delete_existing_data, options_hash, *ar_models_param)
    ar_models = []
    # if we are passed any string names (representing models) convert them to actual AR Models
    ar_models_param.each do |model|
      ar_models << (model.kind_of?(String) ? model.constantize : model)
    end
    if !DB_POSTGRESQL
      raise CoreERR_SQLCompatability, "Unsupported database in import_data_from_file."
    end
    if delete_existing_data && RAILS_ENV_PRODUCTION
      puts "You are about to delete existing data from the production environment database."
      puts "This is usually the wrong course of action. "
      puts "Do not continue unless you are certain that you wish to do this."
      puts "Please confirm this by hitting [ENTER] twice. Ctrl-c to cancel."
      STDIN::gets
      puts "..[ENTER] once more to continue."
      STDIN::gets
    end
    import_data_path = options_hash[:import_data_path]
    import_table_ext = options_hash[:import_table_ext]
    import_table_prefix = options_hash[:import_table_prefix]
    # for live loads we pass in "_versions" to cause the import to
    # go to the versions table, not the live table (we can use migrate_live_versions_data command to promote the records)
    live_table_suffix = options_hash[:live_table_suffix] || ''
    if import_data_path.blank? || import_table_ext.blank? || import_table_prefix.blank?
      raise CoreERR_RequiredParamsNotFound, "Required parameter not found while in import_data_from_file."
    end
    ar_models.each do |ar_model|
      # files are named [import_data_path]/[import_table_prefix][ar_model.table_name][import_table_ext]
      import_file_path = File.expand_path(File::join(import_data_path, import_table_prefix+ar_model.table_name.downcase+import_table_ext))
      zip_file = File::extname(import_file_path) == '.gz' ? import_file_path : "#{import_file_path}.gz"
      if File::exists?(zip_file)
        puts "  Unzipping #{File::basename(zip_file)}.."
        AppUtils.unzip_file(zip_file)
        import_file_path.gsub!(%r{\.gz$}, '')
        del_unzip_file = true
      else
        del_unzip_file = false
      end
      fields_list = ''
      File::open(import_file_path, "r") do |import_file|
        # dynamically load field names for import from header row of table
        fields_list = import_file::gets
        # convert fields_list to comma delim making format: ( field, field, field )
        fields_list = fields_list.gsub("#{IMPORT_DELIMITER}",',')
      end
      puts "  Loading #{File::basename(import_file_path)}.."
      TableLoader::copy_from_file_to_table(ar_model.table_name+live_table_suffix, fields_list, import_file_path,
        {:delete_existing_data => delete_existing_data, :skip_header_row => true,
         :sql_parameters => "WITH DELIMITER '#{IMPORT_DELIMITER}' NULL '#{IMPORT_NULL}'",
         :reset_id_sequence => ar_model})
      if del_unzip_file
        File::delete(import_file_path)
      end
    end #ar_models.each
    # garbage collect any variables from previous loop (some variables are quite large) - in case other tasks are running in the same session
    GC.start
  end #TableLoader.import_data_from_file

  # pass in an appropriate AR Model for :reset_id_sequence option if you want to reset the sequence after loading
  # Options include:
  # :delete_existing_data => truncates all data before loading (default: false)
  # :sql_parameters => permits specifying sql parameters for COPY such as DELIMETER and NULL (default: '')
  # :skip_header_row => skips the first row of table when true (default: false)
  def TableLoader.copy_from_file_to_table(table_name, field_names, import_file_path, options = {})
    delete_existing_data = options[:delete_existing_data] || false
    sql_parameters = options[:sql_parameters] || ''
    skip_header_row = options[:skip_header_row] || false
    # expects appropriate model for resetting sequence
    ar_model = options[:reset_id_sequence]
    File::open(import_file_path, "r") do |import_file|
      # eat first line if there is a header row
      import_file::gets if skip_header_row
      # CUSTOMSQL create dynamic import sql code using 'COPY FROM' sql statement
      import_sql = ''
      import_sql += "TRUNCATE TABLE #{table_name}; " if delete_existing_data
      import_sql += "COPY #{table_name} "
      import_sql += "(#{field_names}) "
      import_sql += "FROM STDIN #{sql_parameters}; "
      # exit if there are no data rows to process
      if import_file.eof? : return false; end
      # CUSTOMSQL we obtain a raw PGconn SQL connection to the database so we can ship data
      # directly to STDIN on the Postgres SQL connection
      raw_conn = ActiveRecord::Base.connection.raw_connection
      # execute the import SQL, which will leave the connection open so we can ship
      # raw records directly to STDIN on the server, via PGconn.putline command (below)
      raw_conn.exec(import_sql)

      # write all data rows to sql server - we write one line at a time to make debugging easier
      loop = TableLoader::get_line_from_file(import_file)
      while !loop.blank?
        raw_conn.putline(loop) if !loop.blank?
        loop = TableLoader::get_line_from_file(import_file)
      end
      # this alternative writes the entire file to disk at once
      # raw_conn.putline(import_file::gets(nil))
      raw_conn.putline("\\.\n") # send Postgres EOF signal: \.<new_line>
      raw_conn.endcopy # tell the driver we are done sending data
      if raw_conn.status != 0
        raise CoreERR_SQLError, "SQL Server reports error code of #{conn.status}. Status code should have been 0"
      end
      # if not nil, consider ar_model is of ActiveRecord::Base and reset its sequence
      if ar_model
        AppUtils::DB::reset_id_sequence(ar_model)
      end
    end  # File::open
  end

  # return each line with the newline value for the platform in question
  # we strip any newlines from the end of each line and replace them with
  # Ruby "\n" which should be platform specific
  def TableLoader::get_line_from_file(file_handle)
    retval = file_handle.gets
    if retval
      retval.chomp!
      retval += "\n"
    end
  end

  SYSTEM_TABLES_REGEX = %r{session|_versions|schema_info|schema_migrations}
  # returns an array of all tables in database, ordered by alpha
  # use option to keep system tables out of array - :exclude_system_tables => true (default: false)
  def TableLoader::get_table_names(options = {})
    exclude_system_tables = options[:exclude_system_tables] || false
    retval = Property.find_by_sql("select tablename as table_name from pg_tables where schemaname='public' order by tablename")
    if exclude_system_tables
      # only return tables which don't match regex values in SYSTEM_TABLES_REGEX
      retval = retval.collect do |t|
        t.table_name.match(SYSTEM_TABLES_REGEX) ? nil : t.table_name
      end
      retval.compact!
    else
      retval = retval.collect {|t| t.table_name}
    end
    retval
  end

  def TableLoader::zip_all_tables_to_files(options = {})
    tables = AppUtils::TableLoader::get_table_names(:exclude_system_tables => true)
    tables.each do |table|
      file_name = File::join(DUMP_DATA_PATH, "#{table}.txt")
      puts AppUtils.get_timing_as_migration("Saved #{table} table to #{file_name}.gz") {
        AppUtils::TableLoader::save_to_file_from_table(table, file_name, {:zip_only => true})
        GC.start # we may be leaving memory open here
      }
    end
  end

  # returns an array of field names for a given table name
  # returns them in the order provided by underlying server
  def TableLoader::get_field_names(table_name)
    get_field_names_sql =<<-get_field_names_sql
      select column_name
      from information_schema.columns
      where table_name = '#{table_name}'
    get_field_names_sql
    fields = Property.find_by_sql(get_field_names_sql)
    fields.collect {|f| f.column_name}
  end

  # will save all data from any active record model to specified file
  # options from save_to_file_from_table also apply
  # addtional options are:
  #   :field_names => columns in model to export (default: all columns in table)
  def TableLoader::save_to_file_from_ar(active_record_class, export_file_path, options = {})
    AppUtils::TableLoader::save_to_file_from_table(active_record_class.table_name, export_file_path, options)
  end

  # save a specified table to specified file
  # options include:
  #   :delimiter => sets column delimiter marker (default = '|')
  #   :null => sets null field marker (default = '[[NULL]]')
  #   :zip_file => causes zip version of file to also be created (default = false)
  #   :zip_only => causes zip version to be made, and plaintext file to be removed (default = false)
  #   :via_temp_table => {:where_sql => sql} -- causes data to be moved into temp table as specified
  #     by :where_sql - data are copied from this temp table into a file
  # if we are passed a file path ending in ".gz" we assume that we are to zip the file
  def TableLoader::save_to_file_from_table(table_name, export_file_path, options = {})
    field_names = options[:field_names] || AppUtils::TableLoader::get_field_names(table_name).join(',')
    export_delimiter = options[:delimiter] || '|'
    export_null = options[:null] || '[[NULL]]'
    zip_file = options[:zip_file] || false
    zip_only = options[:zip_only] || false
    temp_table = options[:via_temp_table]
    if export_file_path.match(%r{\.gz$})
      zip_only = true
      export_file_path.gsub!(%r{\.gz$}, '')
    end
    sql_parameters = " WITH DELIMITER '#{export_delimiter}' NULL '#{export_null}' "
    orig_user = ENV['PGUSER']
    orig_pass = ENV['PGPASSWORD']
    # create export folder if it doesn't exist
    FileUtils::mkpath(File::dirname(export_file_path)) if !File::exists?(File::dirname(export_file_path))
    # we save the output to a temp file, so that we can insert a header row at the top of the file
    # Pg can save header rows, but requires using "CSV-mode" to do it, which has other undesirable effects on output
    tmp_file = Tempfile.new('temp_table')
    tmp_file_path = tmp_file.path
    # if we are copying only limited rows from a table, run a query to move
    # data to a temp table and use that table as table_name
    temp_table_name = nil
    existing_tables = TableLoader::get_table_names
    temp_select_sql = ''
    # if we are instructed to use a temp table, we create it by copying all data from
    # original table into it and then we execute the sql copy on this temp table rather than original
    if !temp_table.blank?
      where_sql = temp_table[:where_sql]
      orig_table_name = table_name
      temp_table_name = 'temp_'+AppUtils::Security::generate_password
      table_name = temp_table_name.dup
      temp_select_sql = "SELECT * INTO #{temp_table_name} FROM #{orig_table_name} WHERE #{where_sql}; "
    end
    begin
      db_config = Rails::Configuration.new.database_configuration[RAILS_ENV]
      ENV['PGUSER'] = db_config['username']
      ENV['PGPASSWORD'] = db_config['password']
      # get connection parameters so we can run psql command
      copy_psql = "\\copy #{table_name} (#{field_names}) to '#{tmp_file_path}' WITH DELIMITER '#{export_delimiter}' NULL '#{export_null}'"
      host = "-h #{db_config['host']}"
      port = db_config['port'] ? "-p #{db_config['port']}" : ""
      database = "-d #{db_config['database']}"
      if !temp_select_sql.blank?
        select_cmd = "psql #{host} #{port} #{database} -q -c \"#{temp_select_sql}\""
        `#{select_cmd}`
      end
      psql_cmd = "psql #{host} #{port} #{database} -q -c \"#{copy_psql}\""
      `#{psql_cmd}`
    ensure # SECURITY - it's important to set these environment vars back to their original state in all cases
      ENV['PGUSER'] = orig_user
      ENV['PGPASSWORD'] = orig_pass
      # drop the temp table if we used one
      if !temp_select_sql.blank?
        # this is just sanity management: we will not drop a table which existed in the system catalog when we started the routine
        if !existing_tables.include?(temp_table_name)
          Property.connection.execute("DROP TABLE IF EXISTS #{temp_table_name}")
        else
          raise CoreERR_Security, "Attempted to drop a system table! '#{temp_table_name}'"
        end
      end
    end
    tmp_file.flush
    # Generate header row for file
    if options[:skip_header_row].blank?
      File::open(export_file_path, "w+") do |export_file|
        header_row = field_names.gsub(',',export_delimiter)
        export_file.puts(header_row)
        File::open(tmp_file_path, 'r') do |tmp|
          until tmp.eof? do
            export_file.write(tmp.read(10.megabytes))
          end
        end
      end
    end
    tmp_file.close

    if zip_file || zip_only
      AppUtils::gzip_file(export_file_path)
      if zip_only and File::exists?("#{export_file_path}.gz")
        File::delete(export_file_path)
      end
    end
    #The following code is commented out due to bug in Postgres/Ruby library
    #Data are copied out from STDOUT but lines are erroneously limited to 511 bytes each
    #File::open(export_file_path, "w") do |export_file|
    #  # generate header row
    #  header_row = field_names.gsub(',',export_delimiter)
    #  export_file.puts(header_row) unless options[:skip_header_row]
    #  import_sql = ''
    #  import_sql += "COPY #{table_name} "
    #  import_sql += "(#{field_names}) "
    #  import_sql += "TO STDOUT #{sql_parameters}; "
    #  # CUSTOMSQL we obtain a raw PGconn SQL connection to the database so we can ship data
    #  # directly to STDIN on the Postgres SQL connection
    #  raw_conn = ActiveRecord::Base.connection.raw_connection
    #  # execute the import SQL, which will leave the connection open so we can ship
    #  # raw records directly to STDIN on the server, via PGconn.putline command (below)
    #        raw_conn.exec(import_sql)
    #
    #        # read all data rows from sql server - we write one line at a time to make debugging easier
    #  buffer = raw_conn.getline
    #  while buffer && buffer != "\\."
    #    export_file.puts(buffer)
    #    buffer = raw_conn.getline
    #  end
    #  export_file.flush
    #  raw_conn.endcopy # tell the driver we are done sending data
    #  if raw_conn.status != 0
    #    raise CoreERR_SQLError, "SQL Server reports error code of #{conn.status}. Status code should have been 0"
    #  end
    #end
  end

end # module TableLoader

module AppUtils
  # simple function which generates timing information that looks like standard migration timing reports
  def AppUtils.get_timing_as_migration(label, &block)
    run_time = Benchmark::realtime {block.call}
    "-- #{label}\n   -> "+run_time.to_s[0..6]+"s"
  end
  # **** File Utilities ****

  def AppUtils.windows?
    !(RUBY_PLATFORM =~ /win32/).nil?
  end

  # returns true if a file is found in the path, false if not
  def AppUtils.file_in_path?(filename)
    retval = false
    search_path = ENV['PATH'].dup
    return retval if search_path.nil?
    search_paths = nil
    if AppUtils.windows?
      search_path.gsub!('\\', '/')
      search_paths = search_path.split(';')
    else
      search_paths = search_path.split(':')
    end
    search_paths.each do |path|
    search_glob = File::join(path, filename+'*')
      if Dir::glob(search_glob).size > 0
        retval = true
        break
      end
    end
    retval
  end

  # returns true if underlying platform has gzip executable
  def AppUtils.has_gzip?(gzip_filename = 'gzip')
    AppUtils::file_in_path?(gzip_filename)
  end

  # unzips zipped_filename to same filename less ".gz"
  # :overwrite_file => overwrites any existing file unless false (default: true -> not specifying this option will cause files to be overwritten!)
  # :unzipped_filename => specify unzipped file name (default: calculated from zipped filename)
  # :delete_zip_file => force zip to be deleted (default is false)
  def AppUtils.unzip_file(zipped_filename, options={})
    retval = false
    overwrite_file = options[:overwrite_file]
    overwrite_file = true if overwrite_file == nil
    unzipped_filename = options[:unzipped_filename] || zipped_filename.gsub(%r{\.gz$}, '')
    delete_zip_file = options[:delete_zip_file] || false
    if unzipped_filename == zipped_filename : raise CoreERR_InvalidParameter, "File to be unzipped does not appear to end in '.gz' - aborting"; end
    if !overwrite_file && File::exists?(unzipped_filename) : raise CoreERR_InvalidParameter, "Target for unzipping '#{unzipped_filename}' already exists and overwriting was not permitted. Aborting unzip procedure."; end
    # use OS gzip function if it exists - avoids buferr altogether!
    if AppUtils::has_gzip?
      cmd = "gzip -d -f -c #{zipped_filename} > #{unzipped_filename}"
      `#{cmd}`
    else # otherwise use crappy Ruby gzip lib (sux on Windows - buffer errors sporadically)
      File::open(unzipped_filename, 'wb') do |unzipped_file|
        unzipped_file.binmode
        gz = File::open(zipped_filename, 'rb')
        gz.binmode
        # this whole mess is due to a bug in Windows which causes Zlib buffer errors
        # when unzipping using the standard gzip library - somehow dereferencing into
        # a StringIO first and then writing that out to the file solves the problem..
        # --> Well.. sometimes. Crashes are less frequent but still present
        begin
          zis = Zlib::GzipReader.new(gz)
          dis = zis.read
          io = StringIO.new(dis)
        ensure
          zis.finish if zis
        end
        unzipped_file.write(io.read)
        unzipped_file.flush
        unzipped_file.fsync
        gz.close
      end
    end
    GC.start
    # make sure the unzipped file is at least as big as the zipped file
    retval = File::exists?(unzipped_filename) && (File::size(unzipped_filename) >= File::size(zipped_filename))
    if delete_zip_file && retval : File::delete(zipped_filename); end
    retval
  end # unzip_file

  # copies source_filename into [source_filename].gz as a zipped file
  # leaves source_filename intact unless :delete_source_filename => true
  # can specify zip filename in options with :zip_filename => [filename]
  def AppUtils.gzip_file(source_filename, options = {})
    delete_source_file = !!options[:delete_source_filename]
    zip_filename = options[:zip_filename] || "#{source_filename}.gz"
    # if the zip file doesn't have a path, use the same path as source file
    if File::basename(zip_filename) == zip_filename : zip_filename = File::join(File::dirname(source_filename), zip_filename); end
    retval = false
    if File::exists?(source_filename)
      File::open(zip_filename, 'wb') do |zip_file|
        File::open(source_filename, 'rb') do |source_file|
          AppUtils::gzip_stream(source_file, zip_file)
        end # File::open.. |source_file|
      end # File::open.. |zip_file|
      # we make sure the zip file exists and is of a reasonable size relative to the source file
      retval = File::exists?(zip_filename) && (File::size(zip_filename) > (File::size(source_filename)/20))
      if delete_source_file && retval && File::exists?(zip_filename)
        File::delete(source_filename)
      end
    end # if File:exists?..
    retval
  end # gzip_file

  # pass in any source_stream and have that stream's zip version streamed out to zip_file
  #   source_stream can be any IO compatible instance (File, StringIO, etc)
  #   zip file is expected to be an read-open File object instance
  def AppUtils.gzip_stream(source_stream, zip_file)
    source_stream.binmode if source_stream.respond_to?(:binmode)
    zip_file.binmode if zip_file.respond_to?(:binmode)
    gz = Zlib::GzipWriter.new(zip_file)
    buffer = ""
    until source_stream.eof? do
      source_stream.read(10.kilobytes, buffer)
      gz.write(buffer)
      gz.flush
      zip_file.fsync if zip_file.respond_to?(:fsync)
    end
    gz.close
  end

  # Opens a file and returns entire contents as a string
  def AppUtils.get_file_as_string(source_filename_with_path)
    IO.read(source_filename_with_path)
  end
  # takes an existing file with full path, and returns filename with new path
  def AppUtils.new_file_path(file_with_path, new_path)
    File.join(new_path, File.basename(file_with_path))
  end

  # compare two files and return true if they are byte-identical
  def AppUtils::file_comp(source_file_name, dest_file_name, binmode = true)
    FileUtils::compare_file(source_file_name, dest_file_name)
  end

  # returns a location suitable for creating temp files
  def AppUtils::get_temp_path
    retval = nil
    Tempfile::open('get_temp_path') do |temp_file|
      retval = File::expand_path(File::dirname(temp_file.path))
    end
    retval
  end
end #AppUtils