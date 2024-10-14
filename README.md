# lazy-serve
a lazy way to run php artisan serve &amp; npm run dev

## What on earth is lazy-serve?
I love effeciency, and hate typing out the two commands to run my Laravel projects (serve & npm run dev).

So I made a bash script that does this for me.

## How to use
Run this code to add it to your laravel project:
```
git clone https://github.com/phpete1/lazy-serve.git ./
chmod +x serve.sh # makes the script executable
```

### Start the server
To run the server execute the script with:

```
./start.sh start
```

To run the server with a specific port (like `php artisan serve --host 0.0.0.0 --port 8080`)
```
./start.sh 0.0.0.0 8080
```
Replace the host and port with whatever you want.
Vite will always use the host and port specified in vite.config.js.

To stop the script:
```
./serve.sh stop
```
### Logs
Everytime you run the server you can view a log of each HTTP request in `_serve.laravel.log` or `_serve.vite.log`
The `_serve.serve.pids` stores the PIDs. We need this so the script know what PIDs to kill when you stop the server.

## Disclaimer
If this script does something bad to your project, I take no responsability. Back up your work before using.

# Happy coding!
