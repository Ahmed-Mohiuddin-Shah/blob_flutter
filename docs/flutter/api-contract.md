# BLOB Flutter — API contract

Base URL = site origin (`AUTH_URL`). JSON unless noted multipart. IDs are **decimal strings**. Auth: `Authorization: Bearer <zitadel_access_token>` (optional where marked public).

Errors: `{ "error": string }` with HTTP 4xx/5xx. Cursor lists: `{ "items": [...], "nextCursor": string | null }`.

Composition / print host notes: [`docs/diff.md`](../diff.md), [`docs/print-layout-host.md`](../print-layout-host.md).

---

## App version

### `GET /api/app-version/check` (public)

Query:

| Param | Required | Notes |
|-------|----------|--------|
| `platform` | yes | `android` \| `ios` |
| `version` | yes | `MAJOR.MINOR.BUGFIX+BUILD` |

Bearer optional: signed-in → user’s app group; else → `public`.

Response:

```json
{
  "status": "ok" | "suggest_update" | "force_update",
  "clientVersion": "1.4.2+87",
  "minVersion": "1.0.0+1",
  "latestVersion": "1.4.2+90",
  "groupKey": "public",
  "groupName": "Public",
  "heading": null,
  "message": null,
  "storeUrl": "https://…",
  "githubUrl": null,
  "iconUrl": null,
  "backgroundUrl": null
}
```

`storeUrl` is platform-specific (`android_store_url` / `ios_store_url`) when set. Prefer `storeUrl` for the update CTA. `heading` / `message` / `iconUrl` / `backgroundUrl` drive the gate UI when present. `githubUrl` is optional source — clients need not surface it; self-builds are unsupported.

### `GET /api/app-version/download` (public)

Query: `platform=android|ios`. Redirects/streams the current **public** cohort APK or IPA. `404` when missing. Web home / sideload use this; in-app updates should prefer `storeUrl`.

Admin group CMS is web-only (`/profile/app-version`).

---

## Session / profile

### `GET /api/me` (auth)

```json
{
  "id": "1",
  "username": "ada",
  "displayName": "Ada",
  "email": "ada@example.com",
  "role": "member",
  "accountStatus": "active",
  "appGroup": { "key": "public", "name": "Public" }
}
```

### `PATCH /api/me` (auth)

Body: `{ "username": "ada" }` — local handle only (blobatar). Display name/email via Zitadel sync, not this route.

---

## Stickers

### `GET /api/stickers` (public; `mine=1` requires auth)

| Param | Notes |
|-------|--------|
| `q` | Search |
| `category` | Category slug |
| `cursor` | Opaque |
| `mine` | `1` = own stickers (any visibility) |
| `status` | With `mine=1`: moderation status filter (`pending_review`, `needs_edit`, `approved`, …) |

### `GET /api/stickers/{id}` (public w/ access rules)

Detail payload: metadata, tags, category, attribution, moderation/processing status, media kinds with status + proxy path `/api/stickers/{id}/media/{kind}`.

### `POST /api/stickers` (member) — multipart

Fields: `title`, `description?`, `visibility`, `categoryId?`, `tags?`, attribution fields, `document` (JSON string), optional `chat`/`thumbnail`/`full`/`mask` blobs, asset refs as required by create flow.

### `PATCH /api/stickers/{id}` (owner/editor) — JSON metadata only

### `POST /api/stickers/{id}/composition` (owner) — save revision + enqueue encode

### `POST /api/stickers/{id}/remix` (member)

### `GET /api/stickers/{id}/media/{kind}` (access-gated)

Kinds: `image` \| `chat` \| `thumbnail` \| `mask` \| `gif` \| `video` \| `og` \| `storyboard` \| …  
Flutter downloads: prefer `chat` for trays; `image`/`gif`/`video` for WhatsApp local export. `og` is website link-preview — ignore for packs.

### `GET /api/stickers/{id}/similar` (public)

### `POST /api/stickers/{id}/attribution-claims` (auth) — create only

### Admin-only sticker actions (web)

`approve` / `reject` / `request-edit` / `reprocess` / search-meta — **not used by Flutter member app**.

---

## Chat keyboard

### `GET /api/keyboard/stickers` (public; richer when auth)

Compact tray feed. Query: `cursor`, `q?`.

Item shape:

```json
{
  "id": "12",
  "title": "Wave",
  "slug": "wave",
  "mimeType": "image/png",
  "chatUrl": "/api/stickers/12/media/chat",
  "favourited": false
}
```

Signed-in: favourites-first then public ready stickers. Anonymous: public ready only. Only stickers with ready `chat` derivative.

---

## Categories / tags / search

### `GET /api/categories` (public)

`{ "items": [{ "id", "name", "slug", "sortOrder", "parentId" }] }`

### `GET /api/tags` (public)

### `GET /api/search` (public; modes gated by role)

### `POST /api/search/agent` (member+) — optional; heavy

---

## Assets

### `POST /api/assets` (member) — upload original → GLASS private prism

### `GET /api/assets/{id}` — as implemented for editor host

---

## Favourites

### `GET /api/favourites` (auth)

### `PUT /api/favourites` / `DELETE /api/favourites` (auth)

Body: `{ "subjectType": "sticker"|"collection"|"sticker_sheet"|"sticker_pack", "subjectId": "…" }`

---

## Collections

### `GET/POST /api/collections`

### `GET/PATCH /api/collections/{slug}`

### `POST /api/collections/{slug}/stickers`

### `DELETE /api/collections/{slug}/stickers/{stickerId}?subjectType=`

### `POST /api/collections/{slug}/pack` — when available

---

## Prints

### Sheets: `GET/POST /api/sheets`, `GET/PATCH/DELETE /api/sheets/{id}`, `…/media/{format}`, `…/stickers`

### Packs: `GET/POST /api/packs`, `GET …/packs/{id}`, media, stickers

`format`: `png` \| `pdf`. Async `status`: `pending` \| `ready` \| `failed` — poll.

---

## Blobbers

### `GET /api/blobbers`, `GET /api/blobbers/{id}`, nested stickers/sheets/collections

### `GET/PATCH /api/blobbers/me`, `POST /api/blobbers/media` (auth)

### Association / edit-request create APIs as on web; **admin approve/reject = web only**

---

## Legal (app copy)

Public JSON for in-app screens (structured sections; not HTML). Website pages at `/about`, `/terms`, `/privacy` use the web variant of the same source.

### `GET /api/legal/about`

### `GET /api/legal/terms`

### `GET /api/legal/privacy`

Shared shape (about adds `tagline`, `lead`, `features`, copyright/why fields):

```json
{
  "slug": "terms",
  "title": "Terms of use",
  "description": "…",
  "updatedAt": "2026-11-01",
  "sections": [{ "heading": "…", "paragraphs": ["…"] }]
}
```

## Health

### `GET /api/health` — liveness / dependency probe (optional for app)

---

## WhatsApp export (client-only — no pack API)

1. Resolve selected sticker ids (user must be allowed to access media).
2. `GET …/media/image` (static) or `gif`/`video` (animated Should).
3. On device: encode Meta-compliant WebP pack + tray; install via WhatsApp.
4. No BLOB endpoints for pack create/store.

---

## Intended admin app-version APIs (web CMS)

| Method | Path | Role |
|--------|------|------|
| `GET/POST` | `/api/admin/app-version/groups` | superadmin |
| `GET/PATCH/DELETE` | `/api/admin/app-version/groups/{id}` | superadmin |
| `POST` | `/api/admin/app-version/groups/{id}/media` | superadmin — multipart `kind=icon\|background` + `file` |
| `POST` | `/api/admin/app-version/binaries` | superadmin — multipart `platform` + `version` + `file` (public APK/IPA; sets `latest_version`) |
| `GET/PUT` | `/api/admin/app-version/deep-links` | superadmin — site-wide App Links / Universal Links config |
| `PATCH` | `/api/admin/app-version/members/{userId}` | superadmin — body `{ "groupId" }` exclusive move |
