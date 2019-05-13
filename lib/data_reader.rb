require 'json'

class DataReader

	def initialize(input_file, changes_file)
		@input_file = input_file
		@changes_file = changes_file
	end

	def extract_data
		data_hash = read_data_from_file(@input_file)
		
		data = data_hash.inject({}) do |acc, (key, value)| 
			acc[key] = hashify_array(value)
			acc
		end

		{
			changes: read_data_from_file(@changes_file),
			data: data
		}
		
	end

	def hashify_array(data)
		data.inject({}) do |acc, item|
			acc[item['id']] = item
			acc
		end
	end

	def read_data_from_file(file_name)
		file      = File.read(file_name)
		JSON.parse(file)
	end
end
