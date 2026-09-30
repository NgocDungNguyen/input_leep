# Using Input Leap across two laptops

Input Leap lets you use one keyboard and mouse on two computers. When the
mouse reaches the edge of one laptop's screen, it moves onto the other one.
The clipboard is shared too (except on Linux under Wayland).

- **Server**: the laptop whose keyboard and mouse you'll use (called `laptop-a` below).
- **Client**: the other laptop (`laptop-b`).

Both laptops must be on the **same Wi‑Fi or LAN** and must be able to reach
each other on **TCP port 24800**.

---

## 1. Install Input Leap on both laptops

You can install a ready-made build, or build one from this repository.

### Option A: download a prebuilt build (easiest)

Get the latest release from <https://github.com/input-leap/input-leap/releases>:

| OS | What to install |
|----|-----------------|
| Windows | the `InputLeapSetup-*.exe` installer |
| macOS | the `.dmg`. Drag it to Applications, then allow it under **System Settings → Privacy & Security → Accessibility** (and **Input Monitoring**) |
| Ubuntu/Debian | the `.deb`: `sudo apt install ./input-leap_*.deb` |
| Fedora/openSUSE | the `.rpm` |
| Any Linux | Flatpak: `flatpak install flathub io.github.input_leap.input-leap` |

### Option B: build it with this repo's GitHub Actions

1. On GitHub, open this repo and go to **Actions → Build tests → Run workflow**.
2. Tick **Build Release binaries** and run it.
3. When the run finishes, download the artifact for your OS from the run page
   (for example, `windows-installer-Windows Qt6` or `input-leap-deb-ubuntu-24-04`).
   Some jobs in the matrix may fail because of old runner images. That is fine
   as long as the job for your OS succeeds.

### Option C: build it on the laptop (Ubuntu/Debian)

```sh
sudo apt install cmake g++ git ninja-build libavahi-compat-libdnssd-dev \
  libssl-dev libxinerama-dev libxrandr-dev libxtst-dev libxkbcommon-dev \
  libglib2.0-dev libice-dev libsm-dev libgl-dev qt6-base-dev qt6-tools-dev \
  qt6-tools-dev-tools qt6-l10n-tools libgtest-dev libgmock-dev
git clone --recurse-submodules https://github.com/ngocdungnguyen/input_leep.git
cd input_leep
B_BUILD_TYPE=Release ./clean_build.sh
sudo cmake --install build
```

---

## 2. Set it up with the GUI (recommended)

**On the client laptop (`laptop-b`):**
1. Open Input Leap and choose **Client**.
2. Note the **Screen name** it shows. You'll type this on the server.
3. Enter the server laptop's IP address (see [Find the IP](#find-the-server-ip)).

**On the server laptop (`laptop-a`):**
1. Open Input Leap and choose **Server**.
2. Click **Configure Server…**.
3. Drag the monitor icon from the top-right onto the grid, next to your own
   screen (left or right, depending on where the laptop sits on your desk).
4. Double-click the new screen and set its name to exactly the client's
   **Screen name** (case-sensitive).
5. Click **OK**, then **Start**.

**Back on the client:** click **Start**.

Both windows should now say **Input Leap is running**. Move the mouse off the
edge of the server's screen and it will appear on the client.

### SSL fingerprint prompt

SSL is on by default. The first time you connect, the client asks you to
trust the server's fingerprint. Check that it matches the one shown on the
server (in the GUI, under the **Server** section), then accept.

---

## 3. Or run it from the command line

This folder includes a ready-made config and two helper scripts
(for Linux and macOS):

1. Edit [`two-laptops.conf`](two-laptops.conf) and replace `laptop-a` and
   `laptop-b` with your real screen names. By default the client laptop is on
   the **right**; swap `right` and `left` if yours sits on the left.
2. In `start-server.sh` and `start-client.sh`, change the `--name` values to
   match.
3. On the server laptop: `./my-setup/start-server.sh`
4. On the client laptop: `./my-setup/start-client.sh 192.168.1.23`
   (use the server's IP).

On Windows, run the same commands from the install folder:
`input-leaps.exe --no-daemon --name laptop-a --config two-laptops.conf` and
`input-leapc.exe --no-daemon --name laptop-b <server-ip>:24800`.

---

## Find the server IP

- **Windows**: `ipconfig`, then look at the IPv4 Address of your Wi‑Fi adapter
- **macOS**: `ipconfig getifaddr en0`
- **Linux**: `hostname -I`

The Input Leap server window also shows its IP addresses.

## Allow port 24800 through the firewall (on the server)

- **Windows**: accept the firewall prompt the first time Input Leap starts.
  Or, in an admin PowerShell:
  `New-NetFirewallRule -DisplayName "Input Leap" -Direction Inbound -Protocol TCP -LocalPort 24800 -Action Allow`
- **Ubuntu (ufw)**: `sudo ufw allow 24800/tcp`
- **Fedora (firewalld)**: `sudo firewall-cmd --permanent --add-port=24800/tcp && sudo firewall-cmd --reload`
- **macOS**: allow incoming connections for Input Leap when prompted.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Client stays on "connecting" | Check the IP, make sure both laptops are on the same network, and open port 24800. Some public or guest Wi‑Fi networks block device-to-device traffic. |
| "Unrecognised client name" in the server log | The screen name in the server config must match the client's name exactly. |
| Mouse won't cross to the other screen | Turn off **Scroll Lock**. Also check that the screen is placed on the correct side in the config. |
| macOS: mouse moves but clicks/keys don't work | Grant **Accessibility** and **Input Monitoring** permission, then restart Input Leap. |
| Linux Wayland: nothing happens | Use a build with libei/portal support (GNOME 45+ / KDE 6), or log in to an "Xorg" session. |
| Clipboard not shared | Clipboard sharing isn't supported under Wayland. |

For more help, see the upstream wiki: <https://github.com/input-leap/input-leap/wiki>
