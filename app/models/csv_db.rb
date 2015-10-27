require 'csv'
class CsvDb
  def header_to_values_map line, header
    Hash[header.zip line]
  end

  def header_to_attributes_map csv_header
    header_conversions = {'Product name' => 'name','Number of pieces' => 'total_count'}
    csv_header.map do |entry|
      header_conversions[entry]
    end
  end

  def parse_file_date filename
    {'purchased_date' => filename.split('.').first}
  end

  def create_product line,model, purchased_date,header
    attributes =  header_to_values_map(line, header).merge(purchased_date)
    model.create(attributes)
  end

  class << self
    def convert_save(model_name, csv_data)
      csv_db = CsvDb.new

      filename = csv_data.original_filename
      purchased_date = csv_db.parse_file_date filename
      csv_file = csv_data.read
      target_model = model_name.classify.constantize

      lines = CSV.parse(csv_file).reject{|e| e.include? nil}
      header = lines.shift
      new_header = csv_db.header_to_attributes_map(header) - [nil]

      lines.each do |line|
        csv_db.create_product line,target_model,purchased_date,new_header
      end
    end
  end
end