https://www.guru.com/work/detail/1874024#
https://www.guru.com/work/detail/1874024

I need for someone with good Go lang skills and socket communications to take this existing code and made some modifications to it.

1.  Need it to run as a service (add the Go code to make run as service) (pretty easy to do this)
2.  Every 5 minutes as a service, need it to read the configuration file, if the file has not changed do nothing, if it has changed, then kill all the listening ports from previous config file, and recreate them with new one.     (Pretty easy to to this)
3.  Change the logging to be a function, and have ability in the config file to turn it on or off.     (Pretty easy to do this)
4.  Have ability to log the actual raw data going back and forth from the port forwards so can capture all data to a file.     Probably the hardest request.  Worry about the timing of it too, if we are logging every byte to a dump file, will it affect the actual communications.  So might have to figure out how to let all the comms occur, then log all the data when it's done. If and only if have that option set in the config file.
