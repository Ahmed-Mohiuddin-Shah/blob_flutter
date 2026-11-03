# BLOB Flutter — API contract

Base URL = site origin (`BASE_URL` / site origin). JSON unless noted multipart. IDs are **decimal strings**. Auth: `Authorization: Bearer <zitadel_access_token>` (optional where marked public).

Errors: `{ "error": string }` with HTTP 4xx/5xx. Cursor lists: `{ "items": [...], "nextCursor": string | null }`.

**Live note (prod `blob.mamajees.com`):** sticker / blobber / sheet / pack **detail routes take numeric ids only** (`BigInt(id)`). Passing a slug → 500/400. Collections use **slug**. Flutter resolves slug deep links via list/`q` then fetches by id.

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

### `GET /api/app-version/download` (public)

Query: `platform=android|ios`. Redirects/streams the current **public** cohort APK or IPA.

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

Flutter stores `appGroup` as the **key** string.

### `PATCH /api/me` (auth)

Body: `{ "username": "ada" }` — local handle only (blobatar).

---

## Stickers

### `GET /api/stickers` (public; `mine=1` requires auth)

List card shape (live):

```json
{
  "id": "37",
  "title": "Rest is Productive",
  "slug": "rest-is-productive",
  "thumbUrl": "/api/stickers/37/media/thumbnail",
  "username": "mohiuddin",
  "category": "Miscellaneous",
  "type": "IMAGE",
  "href": "/stickers/rest-is-productive",
  "favourited": false
}
```

| Param | Notes |
|-------|--------|
| `q` | Search |
| `category` | Category slug |
| `cursor` | Opaque |
| `mine` | `1` = own stickers |
| `status` | With `mine=1`: moderation status filter |

### `GET /api/stickers/{id}` (public w/ access rules)

**`id` must be numeric.** Detail includes `media` as an **array**:

```json
{
  "id": "37",
  "title": "…",
  "slug": "rest-is-productive",
  "moderationStatus": "approved",
  "processingStatus": "ready",
  "media": [
    { "kind": "image", "status": "ready", "url": "/api/stickers/37/media/image" },
    { "kind": "thumbnail", "status": "ready", "url": "/api/stickers/37/media/thumbnail" },
    { "kind": "chat", "status": "ready", "url": "/api/stickers/37/media/chat" }
  ]
}
```

### `GET /api/stickers/{id}/media/{kind}`

Often **302** redirects to GLASS (`glass-*.mamajees.com`). Clients must follow redirects.

Kinds: `image` \| `chat` \| `thumbnail` \| `mask` \| `gif` \| `video` \| `og` \| …

### `GET /api/stickers/{id}/similar`

May return **403** for anonymous guests — Flutter soft-fails to an empty list.

### Other sticker writes

`POST /api/stickers`, `PATCH /api/stickers/{id}`, `POST …/composition`, `POST …/remix`, `POST …/attribution-claims` — member/auth as before.

---

## Chat keyboard

### `GET /api/keyboard/stickers` (public; richer when auth)

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

---

## Categories / tags / search

### `GET /api/categories` / `GET /api/tags`

`{ "items": [...] }`

### `GET /api/search` (public; modes gated by role)

| Param | Notes |
|-------|--------|
| `q` | Query |
| `mode` | Default server-side is **`hybrid`** (403 for guests). Flutter sends **`mode=keywords`**. |
| `scope` | Optional: `stickers` \| `collections` \| `prints` \| `blobbers` |

Live response (Meili), **not** cursor `items`:

```json
{
  "engine": "…",
  "hits": [
    {
      "id": "33",
      "slug": "toptext-party-cat",
      "title": "TopText Party Cat",
      "previewUrl": "https://blob.mamajees.com/api/stickers/33/media/thumbnail",
      "index": "stickers"
    }
  ],
  "facetDistribution": {}
}
```

### `POST /api/search/agent` (member+) — optional; heavy

---

## Favourites

### `GET /api/favourites` / `PUT` / `DELETE` (auth)

Body: `{ "subjectType": "sticker"|"collection"|"sticker_sheet"|"sticker_pack", "subjectId": "…" }`

---

## Collections

### `GET/POST /api/collections`

List item uses **`name`** (not `title`), plus `previewThumbUrls[]`, `itemCount` / `stickerCount`.

### `GET/PATCH /api/collections/{slug}` — slug OK

### Item / pack helpers

`POST …/stickers`, `DELETE …/stickers/{stickerId}`, `POST …/pack` when available.

---

## Prints

There is **no** `/api/prints`. Use sheets + packs:

### Sheets: `GET/POST /api/sheets`, `GET/PATCH/DELETE /api/sheets/{id}` (**numeric id**)

List/detail use **`name`**, `previewUrl`, `status` (`pending` \| `ready` \| `failed`).

### Packs: `GET/POST /api/packs`, `GET …/packs/{id}` (**numeric id**)

Media: `…/media/{format}` with `format`: `png` \| `pdf`.

---

## Blobbers

### `GET /api/blobbers`

```json
{
  "id": "11",
  "displayName": "jukeboxsaints",
  "description": null,
  "href": "/blobbers/jukeboxsaints",
  "linked": false,
  "stickers": [{ "id": "54", "title": "…", "thumbUrl": "…", "href": "…" }]
}
```

### `GET /api/blobbers/{id}` — **numeric id only**

`/api/blobbers/id/{id}` is **not** an API route (HTML). Flutter app path `/blobbers/id/:id` is in-app only; API call is `/api/blobbers/{id}`.

### `GET/PATCH /api/blobbers/me`, `POST /api/blobbers/media` (auth)

Association create: `POST /api/blobber-association-requests`.

---

## Legal (app copy)

### `GET /api/legal/{about|terms|privacy}`

Shared shape. **About** `tagline` is a **string array** live (Flutter joins to one string):

```json
{
  "slug": "about",
  "title": "About",
  "tagline": ["a library", "of stickers"],
  "lead": "…",
  "sections": [{ "heading": "…", "paragraphs": ["…"] }]
}
```

---

## Health

### `GET /api/health`

---

## WhatsApp export (client-only — no pack API)

1. Resolve selected sticker ids.
2. `GET …/media/image` (static) or `gif`/`video` (animated later).
3. On device: encode Meta-compliant WebP pack + tray; install via WhatsApp.

---

## Intended admin app-version APIs (web CMS)

| Method | Path | Role |
|--------|------|------|
| `GET/POST` | `/api/admin/app-version/groups` | superadmin |
| `GET/PATCH/DELETE` | `/api/admin/app-version/groups/{id}` | superadmin |
| `POST` | `/api/admin/app-version/groups/{id}/media` | superadmin |
| `POST` | `/api/admin/app-version/binaries` | superadmin |
| `GET/PUT` | `/api/admin/app-version/deep-links` | superadmin |
| `PATCH` | `/api/admin/app-version/members/{userId}` | superadmin |
