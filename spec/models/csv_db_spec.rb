require 'rails_helper'

RSpec.describe CsvDb, :type => :model do
  it 'should return all the csv values mapped to the header' do
    csv_db = CsvDb.new
    header = ['name','total_count']
    csv_data = ['lappy','10']

    expected_hash = {'name' => 'lappy','total_count' => '10'}

    expected_hash.should == csv_db.header_to_values_map(csv_data,header)
  end

  it 'should return array of attributes of Product model with respect to csv header' do
    csv_db = CsvDb.new
    csv_header = ['Product name','Number of pieces']
    expected_header = ['name','total_count']

    expected_header.should == csv_db.header_to_attributes_map(csv_header)
  end

  it 'should return purchased_date given the csv filename' do
    csv_db = CsvDb.new
    csv_filename = '2015-09-18.csv'
    expected_date = {'purchased_date' => '2015-09-18'}

    expected_date.should == csv_db.parse_file_date(csv_filename)
  end

  it 'should return new product object after every successful save' do
    csv_db = CsvDb.new
    header =  ['name','total_count']

    Product.destroy_all
    Product.count.should == 0
    product = csv_db.create_product(['ipad','10'],Product, {'purchased_date' => '2015-09-09'},header)

    Product.count.should == 1
    product.name.should == 'ipad'
    product.total_count.should == 10
    product.purchased_date.to_s.should == '2015-09-09'
  end
end

