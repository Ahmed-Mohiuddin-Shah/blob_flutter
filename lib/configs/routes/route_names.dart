abstract final class RouteNames {
  const RouteNames._();

  /// App "home" tab (web `/`).
  static const home = stickers;

  static const splash = '/splash';
  static const stickers = '/stickers';
  static const stickerDetail = '/stickers/:slug';
  static const stickerEdit = '/stickers/:slug/edit';
  static const stickerCompose = '/stickers/:slug/compose';
  static const stickerRemix = '/stickers/:slug/remix';

  static const collections = '/collections';
  static const collectionsNew = '/collections/new';
  static const collectionDetail = '/collections/:slug';

  static const prints = '/prints';
  static const printsSheetsNew = '/prints/sheets/new';
  static const printsPacksNew = '/prints/packs/new';
  static const printSheetDetail = '/prints/sheets/:slug';
  static const printPackDetail = '/prints/packs/:slug';

  static const blobbers = '/blobbers';
  static const blobberById = '/blobbers/id/:id';
  static const blobberDetail = '/blobbers/:slug';

  static const search = '/search';
  static const about = '/about';
  static const terms = '/terms';
  static const privacy = '/privacy';
  static const upload = '/upload';

  static const profile = '/profile';
  static const favourites = '/profile/favourites';
  static const uploads = '/profile/uploads';
  static const profilePrints = '/profile/prints';
  static const settings = '/profile/settings';
  static const profileBlobber = '/profile/blobber';
  static const profileBlobberAssociate = '/profile/blobber/associate';

  static String sticker(String slug) => '/stickers/$slug';
  static String collection(String slug) => '/collections/$slug';
  static String sheet(String slug) => '/prints/sheets/$slug';
  static String pack(String slug) => '/prints/packs/$slug';
  static String blobber(String slug) => '/blobbers/$slug';
  static String blobberId(String id) => '/blobbers/id/$id';
}
