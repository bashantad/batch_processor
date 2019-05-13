require_relative './lib/data_reader'
require_relative './lib/playlist_processor'

ARGV[0..1].each do |file|
	unless File.exist?(file)
		puts "#{file} doesn't exist, please enter valid files"
		exit
	end
end

data_reader = DataReader.new(*ARGV[0..1])

extracted_data = data_reader.extract_data

data = extracted_data[:data]
processor = PlaylistProcessor.new(data['users'], data['songs'], data['playlists'])

#processor.debug = true # set the debugger mode on

extracted_data[:changes].each do |command, data|
	data.each do |row|
		processor.send(command.downcase, row) # command is assumed to be defined.
	end
end

data  = {	
	"users" => processor.users.values,
	"playlists" => processor.playlists.values,
	"songs" => processor.songs.values,	
}

output_file = ARGV[2]

File.open(output_file,"w") do |file|
  file.write(JSON.pretty_generate(data))
end
