# BLOB Flutter — architecture

Source of truth for app structure, packages, flavors, navigation, and persistence. Product rules: [`requirements.md`](requirements.md). HTTP: [`api-contract.md`](api-contract.md). UI: [`../style-guide.md`](../style-guide.md).

Structure mirrors the aqarat customer app pattern: layered `configs` / `data` / `logic` / `presentation`, Cubit-only state, static repos, FlutterGen assets, no GetIt.

## Locked stack

| Concern | Package / approach |
|---------|-------------------|
| State | `flutter_bloc` + `equatable` — **Cubit only**. Never use Flutter `setState` for app/feature state |
| Navigation | `go_router` + adaptive shell |
| HTTP | `dio` + static `abstract final class XxxRepo` |
| Prefs | `shared_preferences` |
| Tokens | `flutter_secure_storage` |
| Local SQL | **Drift** (`drift`, `drift_flutter`, `sqlite3_flutter_libs`) |
| Images | `cached_network_image` |
| Icons | Lucide SVGs from `https://lucide.dev/icons/{name}` → `assets/svgs/lucide/` → FlutterGen (**not** `lucide_icons`) |
| Auth | Zitadel PKCE via `flutter_appauth` |
| Editor | `blob_editor` (pub.dev) |
| WhatsApp | `whatsapp_stickers_exporter` (Android + iOS; vendored at `packages/whatsapp_stickers_exporter` with AGP `namespace` patch) |
| Observability | `measure_flutter` + `logging` bridge |
| Env | `flutter_dotenv` — `{FLAVOR}_KEY` in one `.env` |
| Models | `json_annotation` / `json_serializable` |
| Flavors | **dev** + **prod** |

Also: `package_info_plus`, `path_provider`, `image`, `url_launcher`, `connectivity_plus`, `flutter_svg`, `build_runner`, `flutter_gen_runner`.

## Layers

```
lib/
  main.dart
  multiple_bloc_provider.dart
  configs/
    app/global/          # AppColors, AppGlobals, EnvConfigs
    app/extensions/      # XSafeEmitMixin
    remote/api/          # ApiConfigs, TokenRefresher, feature repos
    routes/              # go_router, RouteNames, shell
    utils/               # XUtils, logger→Measure, secure_storage, device
  data/
    models/<feature>/
    local/               # Drift database + tables
    repositories/preferences/shared_prefs.dart
  logic/<feature>/       # *_cubit.dart + *_state.dart
  presentation/
    shell/               # adaptive nav shell
    <feature>/
    widgets/
  gen/                   # flutter_gen output (do not hand-edit)
  services/              # Measure bootstrap
```

Feature folder names stay aligned across layers: `stickers`, `blobbers`, `prints`, `collections`, `search`, `auth`, `me`, `favourites`, `whatsapp_export`, `app_version`, `theme`, `settings`, `home`.

### Flow

UI → Cubit → Repo (HTTP) and/or SharedPrefs / Drift → emit Equatable state. Screen-scoped Cubits via `BlocProvider(create: …)`. App-wide Cubits live on `AppGlobals` and are wired in `MultipleBlocProviders`.

Repos are `abstract final class` with **static** methods returning Dart records `({T? data, ApiError? error})`. Dio clients are singletons (`ApiManager` / `ApiManagerPublic`).

## Adaptive navigation

Tabs: Stickers / Blobbers / Prints / Collections / Search.

| Orientation | Placement |
|-------------|-----------|
| Portrait (phone + tablet) | Bottom bar |
| Landscape (phone + tablet) | Side rail — **right** default; **left** when `sharedPrefs.navRailSide == left` |

`ShellRoute` + `AdaptiveNavShell` reads `MediaQuery.orientation` and prefs. Persist `navRailSide` from Settings. Tab index lives in `HomeNavigationCubit` and must survive orientation changes.

## Flavors

- One `main.dart`; `EnvConfigs` keys via Flutter `appFlavor` → `DEV_BASE_URL`, `PROD_ZITADEL_CLIENT_ID`, etc.
- Android `productFlavors { dev, prod }` with distinct applicationId / display name.
- iOS schemes `dev` / `prod`.
- Launch: `flutter run --flavor dev` / `--flavor prod`.
- **Self-hosted Measure:** per-flavor `MEASURE_API_URL` + platform API keys in `.env` (not measure.sh cloud).

## Auth

1. Cold start → version gate → splash → home (guest OK) or resume session.
2. `flutter_appauth` PKCE against Zitadel; audience = `ZITADEL_API_CLIENT_ID`.
3. Access/refresh in secure storage; Dio attaches `Authorization: Bearer`.
4. Single-flight refresh on 401; clear session on hard failure.
5. `GET /api/me` → `MeCubit` for role, `account_status`, blobatar (never Zitadel picture).

## Persistence split

| Store | Use |
|-------|-----|
| SharedPrefs | theme, nav rail side, onboarding, light JSON caches |
| Secure storage | tokens only |
| Drift | WhatsApp pack drafts, editor drafts / composition JSON, optional offline snapshots |
| `cached_network_image` | remote thumbs (not Drift) |

## WhatsApp export

Download `image` (1024) → resize/encode 512² WebP (+ ~96² tray) with `image` + `path_provider` → stage in Drift → `WhatsappStickersExporter.addStickerPack`. v1 static. iOS: `LSApplicationQueriesSchemes` includes `whatsapp`.

## Observability (self-hosted Measure)

BLOB uses a **self-hosted** [measure.sh](https://measure.sh) instance. Create an app in your dashboard and copy **API URL** + **API Key** (one key per platform).

| Layer | Config |
|-------|--------|
| `.env` | `DEV_MEASURE_API_URL`, `DEV_MEASURE_API_KEY_ANDROID` / `_IOS`, same for `PROD_`, plus `*_MEASURE_ENABLED` |
| Android | Gradle reads `.env` → manifest `sh.measure.android.API_URL` / `API_KEY`; `BlobApplication` calls `Measure.init` |
| iOS | `ios/Flutter/Dev.xcconfig` + `Prod.xcconfig` set `MEASURE_API_URL` / `MEASURE_API_KEY` (mirror `.env` iOS keys); `AppDelegate` → `ClientInfo(apiKey:apiUrl:)` |
| Flutter | `Measure.instance.init` + `MeasureWidget`; `logging` → `Measure.instance.log` |

After changing Measure keys in `.env`, sync iOS xcconfigs (Android picks up `.env` on the next Gradle build):

```text
# ios/Flutter/Dev.xcconfig  → DEV_MEASURE_API_URL + DEV_MEASURE_API_KEY_IOS
# ios/Flutter/Prod.xcconfig → PROD_MEASURE_API_URL + PROD_MEASURE_API_KEY_IOS
```

## Codegen

After `flutter pub get` and when assets/models/Drift schema change:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Produces FlutterGen (`lib/gen/`), `*.g.dart` models, and Drift generated code.

## Hard rules

1. Cubit-only app state — no `setState` for features.
2. Same HTTP API as web — no parallel BFF.
3. Lucide SVGs only via FlutterGen.
4. Busy controls use pink→orange busy feedback.
5. Never embed GLASS API keys.
