require 'playlist_processor'

RSpec.describe PlaylistProcessor do 

	let(:users) do
		{
	      	'1' => {'id' => '1', 'name' => 'John Smith'},
	      	'2' => {'id' => '2', 'name' => 'Tessa Fowler'},
	      	'3' => {'id' => '3', 'name' => 'Georgos Parker'}
	   	}
	end

	let(:songs) do
		{
			'1' => 
		    	{ 
		    		'id' => '1',
		         	'artist' => 'Camila Cabello',
		         	'title' => 'Never Be the Same'
		      	},
	      	'2' => 
		      	{
		        	'id' => '2',
		         	'artist' => 'Zedd',
		         	'title' => 'The Middle'
		      	}
	   	}
	end

	let(:playlists)  do
		{
			'1' => {'id' => '1', 'user_id' => '2', 'song_ids' => ['1','2']},
			'2' => { 'id' => '2', 'user_id' => '2', 'song_ids' => ['1']}
		}
   	end

	before do
		@processor = PlaylistProcessor.new(users, songs, playlists)
	end

	describe '#add_song_to_the_playlist' do

		it 'updates the playlist with user_id and song_ids' do
			options = {
				'playlist_id' => '2',
				'song_id' => '2',
			}
			@processor.add_song_to_the_playlist(options)
			expect(@processor.playlists['2']).to eq({ 'id' => '2', 'user_id' => '2', 'song_ids' => ['1', '2']})
		end

		it 'raises an exception if invalid data is provided' do
			options = {
				'playlist_id' => '4',
				'song_id' => '2'
			}
			expect{
				@processor.add_song_to_the_playlist(options)
			}.to raise_error('Invalid playlist')
		end

	end

	describe '#add_playlist' do
		it 'adds new playlist when proper data is provided' do
			options = {
				'user_id' => '3',
				'song_ids' => ['1', '2']
			}
			expected_hash = {
				'1' => {'id'=>'1', 'song_ids'=>['1', '2'], 'user_id'=>'2'}, 
				'2' => {'id'=>'2', 'song_ids'=>['1'], 'user_id'=>'2'},
				"3" => {"id"=>"3", "song_ids"=>["1", "2"], "user_id"=>"3"}
			}
			@processor.add_playlist(options)
			expect(@processor.playlists).to eq(expected_hash)
		end
	end

	describe '#remove_playlist' do 
		it 'deletes the playlist from the full playlists' do
			options = {'playlist_id' => '2'}
			expected_hash = {'1' => {'id' => '1', 'user_id' => '2', 'song_ids' => ['1','2']}}
			@processor.remove_playlist(options)
			expect(@processor.playlists).to eq(expected_hash)
		end
	end

	describe '#find_user' do

		it 'raises an exception if invalid user is provided' do 
			expect{
				@processor.find_user(3)
			}.to raise_error('Invalid user')
		end

	end

	describe '#find_song' do

		it 'raises an exception if invalid song is provided' do 
			expect{
				@processor.find_song(6)
			}.to raise_error('Invalid song')
		end

	end

	describe '#find_playlist' do

		it 'raises an exception if invalid playlist is provided' do 
			expect{
				@processor.find_playlist(5)
			}.to raise_error('Invalid playlist')
		end

	end

end
