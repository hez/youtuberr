# Youtuberr

YouTuberr allows you to keep a subscrition list and download the new videos for local viewing or backing up.  YouTuberr will automatically write a achives file for each feed so consecutive runs will not try and download files previously downloaded.

## Installation

### Configuring

YouTuberr uses the [YT-DLP python](https://github.com/yt-dlp/yt-dlp) script, so if you are running it locally you will need to install it and set the `ENVYTDLP_PATH` to the location of the executable.

### For Running Locally

- install elixir
- `mix setup`
- `MIX_ENV=prod mix build`
- `_build/prod/rel/youtuberr start`

### Docker

- Build the image `docker build`
- Once built you will need to map in 2 volumes
    - a json file for your subscriptions, set the env `SUBSCRIPTIONS_FILE` if you mount this file any where other then `/app/subscriptions.json`
    - a volume for the downloads, set the env `OUTPUT_DIRECTORY` if you mount this in your container any were other then `/app/downloads`
