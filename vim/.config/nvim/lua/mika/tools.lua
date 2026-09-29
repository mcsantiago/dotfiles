-- Bootstrap external CLI tools that plugins shell out to.
--
-- Telescope's live_grep / grep_string (and fzf's :Rg) call ripgrep (`rg`)
-- directly, so a missing `rg` binary silently breaks them. Mirrors the packer
-- bootstrap in plugins.lua: if the tool isn't on PATH, fetch a prebuilt binary
-- into nvim's data dir — no sudo, no system package manager.

local M = {}

local fn = vim.fn
-- Private bin dir under ~/.local/share/nvim (stdpath('data')).
local bindir = fn.stdpath("data") .. "/bin"

-- Make our bin dir visible to nvim's subprocesses (telescope/fzf spawn via this).
if not string.find(":" .. (vim.env.PATH or "") .. ":", ":" .. bindir .. ":", 1, true) then
  vim.env.PATH = bindir .. ":" .. (vim.env.PATH or "")
end

-- Return the ripgrep release target triple for this platform, or nil if unknown.
local function ripgrep_target()
  local arch = vim.trim(fn.system({ "uname", "-m" }))
  if arch == "amd64" then arch = "x86_64" end
  if arch == "arm64" then arch = "aarch64" end
  if arch ~= "x86_64" and arch ~= "aarch64" then return nil end

  if fn.has("mac") == 1 then
    return arch .. "-apple-darwin"
  elseif fn.has("unix") == 1 then
    -- No static musl build for aarch64; ripgrep ships a gnu build for it.
    if arch == "aarch64" then return "aarch64-unknown-linux-gnu" end
    return "x86_64-unknown-linux-musl"
  end
  return nil -- Windows etc.: fall back to a message.
end

local function downloader(url, out)
  if fn.executable("curl") == 1 then
    fn.system({ "curl", "-fsSL", "-o", out, url })
  elseif fn.executable("wget") == 1 then
    fn.system({ "wget", "-qO", out, url })
  else
    return false, "neither curl nor wget is available"
  end
  return vim.v.shell_error == 0, "download failed (" .. url .. ")"
end

-- Install ripgrep into bindir if `rg` isn't already resolvable.
function M.ensure_ripgrep(version)
  if fn.executable("rg") == 1 then return end
  version = version or "14.1.1"

  local target = ripgrep_target()
  if not target then
    vim.notify("[tools] Can't auto-install ripgrep on this platform — install it manually.", vim.log.levels.WARN)
    return
  end

  local name = string.format("ripgrep-%s-%s", version, target)
  local url = string.format(
    "https://github.com/BurntSushi/ripgrep/releases/download/%s/%s.tar.gz", version, name)
  local tmp = fn.tempname() .. ".tar.gz"

  fn.mkdir(bindir, "p")
  vim.notify("[tools] Installing ripgrep " .. version .. "...", vim.log.levels.INFO)

  local ok, err = downloader(url, tmp)
  if not ok then
    vim.notify("[tools] ripgrep " .. err, vim.log.levels.ERROR)
    return
  end

  -- Pull just the rg binary out of the tarball into bindir.
  fn.system({ "tar", "-xzf", tmp, "-C", bindir, "--strip-components=1", name .. "/rg" })
  local extracted = vim.v.shell_error == 0
  pcall(os.remove, tmp)

  if not extracted then
    vim.notify("[tools] ripgrep extract failed", vim.log.levels.ERROR)
    return
  end
  fn.system({ "chmod", "+x", bindir .. "/rg" })

  if fn.executable("rg") == 1 then
    vim.notify("[tools] ripgrep installed to " .. bindir, vim.log.levels.INFO)
  else
    vim.notify("[tools] ripgrep install did not resolve on PATH", vim.log.levels.WARN)
  end
end

M.ensure_ripgrep()

return M
