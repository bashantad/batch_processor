class PlaylistProcessor
	
	attr_accessor :debug
	attr_reader :users, :songs, :playlists, :last_playlist_id

	def initialize(users, songs, playlists)
		@playlists = playlists
		@last_playlist_id = @playlists.size
		@songs = songs
		@users = users		
	end

	def add_song_to_the_playlist(options)
		playlist = find_playlist(options['playlist_id'])
		song = find_song(options['song_id'])

		log "updating playlist id #{options['playlist_id']} by adding song_id #{options['song_id']}"
		
		playlist['song_ids'] << options['song_id']
		@playlists[options['playlist_id']] = playlist		
	end

	def add_playlist(options)
		user = find_user(options['user_id'])
		options['song_ids'].each do |song_id| # Making sure the ids are from existing songs
			find_song(song_id)
		end
		log "creating new playlist for user #{options['user_id']} with songs #{options['song_ids']}"

		@last_playlist_id = @last_playlist_id + 1
		@playlists[@last_playlist_id.to_s] = build_new_playlist(options)		
	end

	def remove_playlist(options)
		playlist = find_playlist(options['playlist_id'])
		log "removing playlist with playlist id #{playlist['playlist_id']}"
		@playlists.delete(options['playlist_id'])		
	end

	def find_user(user_id)
		user = @users[user_id]
		raise "Invalid user" unless user
		user		
	end

	def find_song(song_id)
		song = @songs[song_id]
		raise "Invalid song" unless song
		song
	end

	def find_playlist(playlist_id)
		playlist = @playlists[playlist_id]
		raise "Invalid playlist" unless playlist
		playlist
	end

	def build_new_playlist(options)
		{
			'id' => @last_playlist_id.to_s,
			'user_id' => options['user_id'],
			'song_ids' => options['song_ids']
		}
	end

	def log(message)
		@debug && puts(message)
	end
end
