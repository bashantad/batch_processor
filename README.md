# Batch Processor Program
In order to run the program, you need to install `Ruby` and `Bundler`
Once ruby and bundler are installed, please run the following command to install the dependencies (json and rspec)
```
$ bundle install
```

### Execute the program
You need to run following commands to execute the program.
```sh
$ ruby main.rb mixtape.json changes.json output.json
OR
$ bash batch_process mixtape.json changes.json output.json
```
### Assumptions
  - The files are not big and wouldn't require much longer time to process(read/write)
  - ids for the playlist would be incremental starting with size as lastIndex.
  - Exceptions haven't been handled properly (eg: when you are modifying the removed playlist)
  - It takes only three commands(`ADD_SONG_TO_THE_PLAYLIST`, `ADD_PLAYLIST` and `REMOVE_PLAYLIST` from `changes.json`. The data has to be provided in array format for the changes. eg:
  ```
  "ADD_SONG_TO_THE_PLAYLIST": [{
		"playlist_id": "2",
		"song_id": "1"
	},
	{
		"playlist_id": "3",
		"song_id": "2"
	}]
  ```
  For more information, please see the `changes.json` file.

### Automated tests
  - Test is written for only one file(playlist_processor)
  - Run test by typing `$ rspec spec/` in terminal

### How to validate the output
  - I have validated using `vimdiff mixtape.json output.json`. We can write proper program to validate the output.

### How to scale this application for large data sets
I would change the followings when we need to process the large amount of data
- I would move the data(`mixtype.json`) in other places to make the data lookup much easier and faster(eg: NoSql lookup, elastic search, Hadoop or even RDBMS might work with proper indexing for upto certain number of records)
- If we need to do it from file, another alternative is to do it in multiprocessing environment (with data divided into clusters and later on merging them)
- Another alternative is to copy the file first into output.json and modify the file based on the command by keeping track of file pointers. 
- If we have limited memory, then hash may not be an option. I would probably do a binary search to find the proper data as they are already sorted. 
- I would create separate data models for playlist, songs and users
- Obviously, for production code, I would write more tests and handle exceptions properly. 

