### docker-dropbox-sync-hf

Free Docker instance running on Hugging Face Spaces with built-in Rclone sync to Dropbox. Automate secure, seamless file sync between your container and cloud storage using open infrastructure — no servers or credit cards required.

## Installation & Usage

### 1. Get Dropbox API Access

- Go to [Dropbox App Console](https://www.dropbox.com/developers)
- Create a new app with your account
- Set the required permissions and scope (entire Dropbox if needed)

### 2. Install rclone and Configure Dropbox

On any machine with browser access:

```sh
curl https://rclone.org/install.sh | sudo bash
rclone config
```

- Follow the prompts to create a new remote for Dropbox.
- Authenticate with Dropbox via your browser as instructed.

### 3. Get Your `rclone.conf` Content

- Find the path to your rclone config file:

  ```sh
  rclone config file
  ```

- Output the contents:

  ```sh
  cat /path/to/rclone.conf
  ```

- Copy the entire contents of this file. This is your `RCLONE_CONF_TEXT`.

### 4. useage copy the file of you saas (for example N8N) to huggingface space root dir then set the `RCLONE_CONF_TEXT` to the hf secrets. done

### 5. To avoid the sleep

use https://console.cron-job.org/ to send the request to the docker to /heath route to aviod the stoping of the conatior after few min set to 10 min cron on it.


