# docker-dropbox-sync-hf

Free Docker instance running on Hugging Face Spaces with built-in Rclone sync to Dropbox. Automate secure, seamless file sync between your container and cloud storage using open infrastructure—no servers or credit cards required.

---

## 🚀 Installation & Usage

### 1️⃣ Get Dropbox API Access

- Go to the [Dropbox App Console](https://www.dropbox.com/developers)
- Create a new app with your account
- Set the required permissions and scope (entire Dropbox if needed)

---

### 2️⃣ Install rclone and Configure Dropbox

On any machine with browser access:

```sh
curl https://rclone.org/install.sh | sudo bash
rclone config
```

- Follow the prompts to create a new remote for Dropbox.
- Authenticate with Dropbox via your browser as instructed.

---

### 3️⃣ Get Your `rclone.conf` Content

- Find the path to your rclone config file:

  ```sh
  rclone config file
  ```

- Output the contents:

  ```sh
  cat /path/to/rclone.conf
  ```

- Copy the entire contents of this file. This is your `RCLONE_CONF_TEXT`.

---

### 4️⃣ Usage

Copy the data directory of your SaaS app (for example, N8N) to the Hugging Face Space root directory, then set the `RCLONE_CONF_TEXT` as a Hugging Face secret. Done!

---

### 5️⃣ Prevent Container Sleep

Use [console.cron-job.org](https://console.cron-job.org/) to send a request to the `/health` route of your Docker container.  
Set up a cron job to ping every 10 minutes to prevent the container from stopping due to inactivity.


