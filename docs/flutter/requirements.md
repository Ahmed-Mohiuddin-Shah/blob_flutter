# BLOB Flutter app — requirements

Member-facing Flutter client for BLOB. Admin/superadmin stays on the website. Source of truth for product rules: [`docs/blob-requirements.md`](../blob-requirements.md). HTTP contract: [`api-contract.md`](api-contract.md). UI language: [`docs/style-guide.md`](../style-guide.md). App structure / packages / flavors: [`architecture.md`](architecture.md).

## Locked stack (summary)

Cubit-only `flutter_bloc` (never `setState` for app state), `go_router`, `dio`, `shared_preferences`, `flutter_secure_storage`, **Drift**, `cached_network_image`, Lucide SVGs via FlutterGen, Zitadel PKCE (`flutter_appauth`), `blob_editor`, `whatsapp_stickers_exporter`, `measure_flutter` + `logging`. Flavors: **dev** + **prod**. Full detail in [`architecture.md`](architecture.md).

## Scope

| In | Out |
|----|-----|
| Public browse + search | Admin moderation of others |
| Signed-in member create/edit/remix/prints | Fleet / workers / prompts / landing CMS |
| Own library (uploads / pending / needs-edit) | Claims **queue** (create claim = in) |
| Favourites, collections, blobber self-profile | Server WhatsApp sticker-pack pipeline |
| On-device WhatsApp sticker-pack export | Forking `blob_editor` |
| App version gate via BLOB check API | |

## Auth

- Register a **native Zitadel PKCE** app in the same project as the web client.
- Store/refresh tokens on device; call BLOB with `Authorization: Bearer <access_token>`.
- Audience = `ZITADEL_API_CLIENT_ID` (same as web). Cookie session is web-only.

## Version gate (must)

On cold start (and optionally on resume):

1. Read local version as `major.minor.bugfix+build` (e.g. `1.4.2+87`).
2. `GET /api/app-version/check?platform=android|ios&version=…` (Bearer optional).
3. Handle `status`:
   - `force_update` — block UI; open `storeUrl`; no dismiss. Use `heading` / `message` / `iconUrl` / `backgroundUrl` when present.
   - `suggest_update` — dismissible banner / sheet (same presentation fields).
   - `ok` — continue.

Anonymous checks use the **`public`** cohort. Signed-in checks use the user’s app group. Cohorts, APK/IPA uploads, deep-link association files, and CMS are web/superadmin only; the app only consumes the check (+ optional `appGroup` on `/api/me`). Prefer store URLs for updates — direct APK/IPA is a website sideload path.

## Feature parity (member)

### Public

- Landing-equivalent home (featured/categories via public list APIs / curated browse).
- Stickers browse + detail (incl. related/similar).
- Collections browse + detail.
- Prints (sheets/packs) browse + detail + PNG/PDF download.
- Blobbers directory + profile.
- Keyword search; semantic/hybrid/visual/agent per role capabilities (same as web).
- About / terms / privacy via `GET /api/legal/{about|terms|privacy}` (app-specific JSON); web pages remain at `/about`, `/terms`, `/privacy`.

### Signed-in

- Profile: blobatar(`username`), role/status; `PATCH` username via `/api/me`.
- Favourites (sticker | collection | sheet | pack).
- Own uploads / pending / needs-edit lists (`GET /api/stickers?mine=1&status=`).
- Create sticker: assets → stickers + composition (editor-required).
- Edit metadata; compose/revise; remix.
- Collections create / manage items (1–60).
- Attribution claim create.
- Blobber self CMS + association request.
- Create sheets/packs; collection → pack where API allows.

### Editor

- Consume published **`blob_editor`** (pub.dev) — same Composition JSON v2 as web.
- Mobile-first: touch, ~44px targets, narrow/wide layouts per [`docs/diff.md`](../diff.md).
- Previews: chat 128 / thumbnail 256 / full 1024.
- Cutout brush + polygon in-editor (no `/cutout` API).
- GIF/MP4 encode is **server-only**; poll processing until ready.
- Print layout: Flutter preview PNG; PDF from worker ([`docs/print-layout-host.md`](../print-layout-host.md)).

## WhatsApp sticker-pack export (extra, app-only)

- User selects approved stickers → build pack **on device**.
- Source media: download `image` (1024 still) → resize/encode **512×512 WebP** (+ tray ~96²) per Meta sticker rules.
- Install via platform WhatsApp APIs (Android ContentProvider / iOS sticker APIs).
- **v1:** static WebP. **Should:** animated from `gif`/`video`.
- Do **not** request new BLOB media kinds or `blob_editor` WhatsApp sizes. Website keeps OG link-preview only.

## Chat keyboard

- Use `GET /api/keyboard/stickers` for compact trays (ready `chat` 128 URLs).
- Favourites-first when signed in; public browse subset when anonymous.

## Responsive UI

- Phone / tablet × portrait / landscape as one adaptive system (not two apps).
- Tabs: Stickers / Blobbers / Prints / Collections / Search.
- **Portrait** (phone + tablet): bottom nav.
- **Landscape** (phone + tablet): side rail — right by default, left when the user chooses that in Settings (persisted in SharedPrefs as `navRailSide`).
- Editor: stacked chrome on narrow; tools \| stage \| previews on wide; denser grids (3 → 4 → 6).
- Print detail: stacked → split media/meta.
- Orientation changes must not orphan actions under the keyboard/safe areas or drop the selected tab.

## Visual language

Follow the style guide: Bloby soft radii, Zune eyebrows + overflow titles, pink→orange accents, busy gradient on async controls, Lucide icons as downloaded SVGs (FlutterGen — not the `lucide_icons` package), blobatar avatars (never Zitadel pictures), light/dark/system.

### Glass / bubbly morph (advisory)

Apple Liquid Glass is not a Flutter primitive. Bloby organic radii already align. Optional enhancement: Impeller + `BackdropFilter`, morphing blob shapes, spring shared elements — progressive only; keep AA contrast and busy feedback; do not tank mid-range Android GPUs. Not a ship blocker.

## Hard rules

1. Same HTTP API as web Route Handlers — no parallel BFF.
2. Preview ≡ export via shared composition document.
3. Never embed GLASS API keys; use BLOB media proxy URLs.
4. Tags ALL CAPS on save (server normalizes).
5. Members only upload when `account_status=active` and role allows.
